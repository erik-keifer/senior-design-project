//
//  DeveloperUploadView.swift
//  Design
//
//  Created by Austin Kim on 1/23/26.
//

import SwiftUI

struct DeveloperUploadView: View {
    @Environment(\.dismiss) private var dismiss

    let repo: HealthDataRepository
    let api: SleepFocusAPI

    @State private var startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()

    @State private var isSending = false
    @State private var statusText: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Range") {
                    DatePicker("Start", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Upload") {
                    Button(isSending ? "Sending..." : "Send raw HealthKit data") {
                        Task { await send() }
                    }
                    .disabled(isSending || startDate >= endDate)

                    if let statusText {
                        Text(statusText)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Developer Upload")
        }
    }

    @MainActor
    private func send() async {
        isSending = true
        statusText = nil
        do {
            let payload = try await repo.fetchAll(from: startDate, to: endDate)
            try await api.postInput(payload)
            statusText = "Sent. HR: \(payload.heartRate.count), HRV: \(payload.hrv.count), Sleep: \(payload.sleep.count)"
        } catch {
            statusText = "Failed: \(error.localizedDescription)"
        }
        isSending = false
    }
}
