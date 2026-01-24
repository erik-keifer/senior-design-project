//
//  HealthModels.swift
//  Design
//
//  Created by Austin Kim on 1/23/26.
//

import Foundation

struct RawHRSample: Codable {
    let timestamp: Date
    let bpm: Double
}

struct RawHRVSample: Codable {
    let timestamp: Date
    let ms: Double
}

struct RawSleepSample: Codable {
    let start: Date
    let end: Date
    let value: Int  // HKCategoryValueSleepAnalysis rawValue
    let source: String?
}

struct InputPayload: Codable {
    let rangeStart: Date
    let rangeEnd: Date
    let heartRate: [RawHRSample]
    let hrv: [RawHRVSample]
    let sleep: [RawSleepSample]
}
