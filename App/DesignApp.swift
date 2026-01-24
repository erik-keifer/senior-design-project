import SwiftUI

@main
struct DesignApp: App {
    @StateObject private var healthAuth = HealthAuth()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(healthAuth)
                .task {
                    await healthAuth.refreshAuthStatus()
                }
        }
    }
}



