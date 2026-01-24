//
//  HealthAuth.swift
//  Design
//
//  Created by Austin Kim on 1/23/26.
//

import Foundation
import HealthKit
import Combine
import SwiftUI

@MainActor
final class HealthAuth: ObservableObject {
    private let healthStore = HKHealthStore()

    @AppStorage("healthKitConnected") private var healthKitConnected: Bool = false

    @Published private(set) var isAuthorized: Bool = false
    @Published private(set) var lastErrorMessage: String?

    func connect() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            lastErrorMessage = "Health data is not available on this device."
            isAuthorized = false
            return
        }

        guard
            let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let hrv = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        else {
            lastErrorMessage = "Failed to create HealthKit types."
            isAuthorized = false
            return
        }

        let toShare: Set<HKSampleType> = []
        let toRead: Set<HKObjectType> = [sleep, heartRate, hrv]

        do {
            try await healthStore.requestAuthorization(toShare: toShare, read: toRead)
            healthKitConnected = true
            lastErrorMessage = nil
            await refreshAuthStatus()
        } catch {
            lastErrorMessage = error.localizedDescription
            isAuthorized = false
        }
    }

    func disconnect() {
        // Cannot revoke HealthKit permissions in app.
        // "Disconnect" is a local state + send user to Settings if they want to revoke.
        healthKitConnected = false
        isAuthorized = false
        openAppSettings()
    }

    func refreshAuthStatus() async {
        guard healthKitConnected else {
            isAuthorized = false
            return
        }

        // Validate read access by doing a tiny query (sleep is a good one).
        do {
            let ok = try await canReadAnySleepSample()
            isAuthorized = ok
        } catch {
            // If query fails or returns nothing, treat as not authorized.
            isAuthorized = false
        }
    }

    private func canReadAnySleepSample() async throws -> Bool {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return false }

        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: end) ?? end
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { cont in
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 1, sortDescriptors: nil) { _, samples, error in
                if let error { cont.resume(throwing: error); return }
                cont.resume(returning: (samples?.isEmpty == false))
            }
            healthStore.execute(query)
        }
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
