//
//  HomeView.swift
//  Senior Design Project
//
//  Created by Austin Kim on 12/19/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = SmartAlarmViewModel()
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Smart Alarm"){
                    DatePicker(
                        "Ideal wake-up time",
                        selection: $vm.wakeTime,
                        displayedComponents: .hourAndMinute
                    )
                    Toggle("Within/Time Limit", isOn: $vm.useLatestByTime)
                    if vm.useLatestByTime {
                       DatePicker(
                           "By",
                           selection: $vm.latestByTime,
                           displayedComponents: .hourAndMinute
                       )
                   } else {
                       Stepper(value: $vm.windowMinutes, in: 5...90, step: 5) {
                           Text("Within: \(vm.windowMinutes) min")
                       }
                   }
                    Toggle("Enable smart alarm", isOn: $vm.isEnabled)
                    Button("Schedule"){
                        vm.schedule()
                    }.disabled(!vm.isEnabled)
                }
                
                if let status = vm.statusText {
                    Section("Status") {
                        Text(status)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
