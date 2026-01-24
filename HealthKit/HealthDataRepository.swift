//
//  HealthDataRepository.swift
//  Design
//
//  Created by Austin Kim on 1/23/26.
//

import Foundation
import HealthKit

final class HealthDataRepository {
    private let healthStore: HKHealthStore

    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
    }

    func fetchHeartRate(from start: Date, to end: Date) async throws -> [RawHRSample] {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { cont in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error { cont.resume(throwing: error); return }
                let hr = (samples as? [HKQuantitySample])?.compactMap { s in
                    let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    return RawHRSample(timestamp: s.startDate, bpm: s.quantity.doubleValue(for: unit))
                } ?? []
                cont.resume(returning: hr as! [RawHRSample])
            }
            self.healthStore.execute(query)
        }
    }

    func fetchHRV(from start: Date, to end: Date) async throws -> [RawHRVSample] {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { cont in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error { cont.resume(throwing: error); return }
                let hrv = (samples as? [HKQuantitySample])?.compactMap { s in
                    let unit = HKUnit.secondUnit(with: .milli)
                    return RawHRVSample(timestamp: s.startDate, ms: s.quantity.doubleValue(for: unit))
                } ?? []
                cont.resume(returning: hrv as! [RawHRVSample])
            }
            self.healthStore.execute(query)
        }
    }

    func fetchSleep(from start: Date, to end: Date) async throws -> [RawSleepSample] {
        guard let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { cont in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error { cont.resume(throwing: error); return }
                let sleep = (samples as? [HKCategorySample])?.map { s in
                    RawSleepSample(
                        start: s.startDate,
                        end: s.endDate,
                        value: s.value,
                        source: s.sourceRevision.source.name
                    )
                } ?? []
                cont.resume(returning: sleep)
            }
            self.healthStore.execute(query)
        }
    }

    func fetchAll(from start: Date, to end: Date) async throws -> InputPayload {
        async let hr = fetchHeartRate(from: start, to: end)
        async let hrv = fetchHRV(from: start, to: end)
        async let sleep = fetchSleep(from: start, to: end)
        return InputPayload(rangeStart: start, rangeEnd: end,
                            heartRate: try await hr,
                            hrv: try await hrv,
                            sleep: try await sleep)
    }
}
