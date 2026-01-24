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
                        ? "Disconnect from Apple HealthKit"
                        : "Connect to Apple HealthKit"
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
