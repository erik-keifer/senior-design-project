import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {

            // Home
            NavigationStack {
                ContentView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            // Insights
            NavigationStack {
                InsightsView()
            }
            .tabItem {
                Label("Insights", systemImage: "chart.bar")
            }

            // Coach (was Chat)
            NavigationStack {
                ChatView() // can rename to CoachView later
            }
            .tabItem {
                Label("Coach", systemImage: "bubble.left.and.bubble.right")
            }

            // Settings
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    RootView()
}







































