//
//  ContentView.swift
//  Senior Design Project
//
//  Created by Erik Keifer on 12/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart")
                }
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

// TODO: Move to HealthView.swift
struct HealthView: View {
    var body: some View {
        Text("Health")
    }
}

// TODO: Move to SettingsView.swift
struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}

#Preview {
    ContentView()
}







































