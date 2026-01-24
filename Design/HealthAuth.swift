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

    @Published private(set) var isAuthorized: Bool = false
    @Published private(set) var lastErrorMessage: String?

    func connect() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            lastErrorMessage = "Health data is not available on this device."
            isAuthorized = false
            return
        }

        guard
            let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let hrv = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        else {
            lastErrorMessage = "Failed to create HealthKit types."
            isAuthorized = false
            return
        }

        let toShare: Set<HKSampleType> = []
        let toRead: Set<HKObjectType> = [sleepAnalysis, heartRate, hrv]

        do {
            try await healthStore.requestAuthorization(toShare: toShare, read: toRead)
            lastErrorMessage = nil
            isAuthorized = true
        } catch {
            lastErrorMessage = error.localizedDescription
            isAuthorized = false
        }
    }

    func disconnect() {
        // You cannot revoke HealthKit permissions from inside the app.
        // Best UX: open Settings so the user can toggle permissions off.
        openAppSettings()
        isAuthorized = false
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

