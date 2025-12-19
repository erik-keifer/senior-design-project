//
//  SmartAlarmViewModel.swift
//  Senior Design Project
//
//  Created by Austin Kim on 12/19/25.
//

import Foundation
import Combine

@MainActor
final class SmartAlarmViewModel: ObservableObject {
    @Published var wakeTime: Date = .now
    
    // Mode: Within versus Time limit
    @Published var useLatestByTime: Bool = false
    @Published var windowMinutes: Int = 30
    @Published var latestByTime: Date = .now.addingTimeInterval(30*60)
    
    @Published var isEnabled: Bool = true
    @Published var statusText: String? = nil

    // TODO: Implement actual alarm feature/algorithm
    func schedule() {
        if useLatestByTime {
            statusText = "Scheduled between \(formattedTime(wakeTime)) and \(formattedTime(latestByTime))"
        } else {
            statusText = "Scheduled around \(formattedTime(wakeTime)) (±\(windowMinutes) min)"
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
