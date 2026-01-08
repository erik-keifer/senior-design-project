//
//  HomeView.swift
//  Senior Design Project
//
//  Created by Austin Kim on 12/19/25.
//

// TODO: Split into another file
import Charts
import SwiftUI

struct HomeView: View {
    @StateObject private var vm = SmartAlarmViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Sleep-Focus")
                            .font(.system(.largeTitle, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        SleepQualityCard()
                        FocusPredictionCard()

                        SmartAlarmCard(vm: vm)

                        if let status = vm.statusText {
                            StatusCard(text: status)
                        }

                        Spacer(minLength: 16)
                    }
                }
                .padding(8)
                .padding(.top)
            }
        }
    }
}

struct SleepQualityCard: View {
    var score: String = "8.2/10"  // replace later

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sleep Quality")
                .font(.headline)
            Text(score)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 18, x: 0, y: 8)
        .padding(.horizontal)
    }
}

struct FocusPredictionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Focus Window")
                .font(.headline)

            FocusChartView()
                .frame(height: 150)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 8)
        .padding(.horizontal)
    }
}

struct FocusPoint: Identifiable {
    let id = UUID()
    let time: String
    let value: Double
}

let focusData: [FocusPoint] = [
    .init(time: "8 AM", value: 5),
    .init(time: "10 AM", value: 9),  // high focus
    .init(time: "2 PM", value: 3),  // low focus
    .init(time: "4 PM", value: 7),
    .init(time: "6 PM", value: 8),
]

let highest = focusData.max(by: { $0.value < $1.value })
let lowest = focusData.min(by: { $0.value < $1.value })

struct FocusChartView: View {
    var body: some View {
        Chart {
            // Area shading
            ForEach(focusData) { point in
                AreaMark(
                    x: .value("Time", point.time),
                    y: .value("Focus", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [
                            Color.red.opacity(0.35),
                            Color.red.opacity(0.05),
                            Color.clear,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }

            // Smooth line
            ForEach(focusData) { point in
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("Focus", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.red)
                .lineStyle(.init(lineWidth: 4))
            }

            // Label High Focus
            if let highest = highest {
                PointMark(
                    x: .value("Time", highest.time),
                    y: .value("Focus", highest.value)
                )
                .foregroundStyle(.red)
                .annotation(position: .top) {
                    Text("High\nFocus")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                }
            }

            // Label Low Focus
            if let lowest = lowest {
                PointMark(
                    x: .value("Time", lowest.time),
                    y: .value("Focus", lowest.value)
                )
                .foregroundStyle(.red)
                .annotation(position: .bottom) {
                    Text("Low\nFocus")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis(.hidden)
    }
}

struct SmartAlarmCard: View {
    @ObservedObject var vm: SmartAlarmViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart Alarm")
                .font(.headline)

            HStack {
                Text("Ideal wake-up time")
                Spacer()
                DatePicker(
                    "",
                    selection: $vm.wakeTime,
                    displayedComponents: .hourAndMinute
                ).labelsHidden()
            }
            Divider()
            Toggle("Within / Time Limit", isOn: $vm.useLatestByTime)

            if vm.useLatestByTime {
                HStack {
                    Text("By")
                    Spacer()
                    DatePicker(
                        "",
                        selection: $vm.latestByTime,
                        displayedComponents: .hourAndMinute
                    ).labelsHidden()
                }
            } else {
                HStack {
                    Text("Within")
                    Spacer()
                    Stepper(
                        "\(vm.windowMinutes) min",
                        value: $vm.windowMinutes,
                        in: 5...90,
                        step: 5
                    ).labelsHidden()
                }
            }
            Divider()

            Toggle("Enable smart alarm", isOn: $vm.isEnabled)

            Button(action: { vm.schedule() }) {
                HStack {
                    Spacer()
                    Text("Schedule")
                        .fontWeight(.semibold)
                    Spacer()
                }
            }.buttonStyle(.borderedProminent)
                .disabled(!vm.isEnabled)
        }
        .padding(20)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 18, x: 0, y: 8)
        .padding(.horizontal)
    }
}

struct StatusCard: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status")
                .font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 18, x: 0, y: 8)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
