import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var healthAuth: HealthAuth

    var body: some View {
        Form {
            Section(header: Text("Account")) {
                HStack {
                    Text("Profile")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Notifications")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                
                Button(
                    healthAuth.isAuthorized
                        ? "Disconnect Apple HealthKit"
                        : "Connect Apple HealthKit"
                ) {
                    if healthAuth.isAuthorized {
                        healthAuth.disconnect()
                    } else {
                        Task { await healthAuth.connect() }
                    }
                }
            }

            Section(header: Text("App")) {
                Toggle("Dark Mode", isOn: .constant(false))
                Toggle("Sounds", isOn: .constant(true))
            }
            
            #if DEBUG
                Section(header: Text("Developer")) {
                    NavigationLink("Upload Raw HealthKit Data") {
                        DeveloperUploadView(
                            repo: HealthDataRepository(),
                            api: SleepFocusAPI()
                        )
                    }
                }
            #endif

            Section {
                Button(role: .destructive) {
                    // logout later
                } label: {
                    Text("Sign Out")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView().environmentObject(HealthAuth())
    }
}
