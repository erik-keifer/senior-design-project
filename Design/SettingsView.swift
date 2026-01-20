import SwiftUI

struct SettingsView: View {
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
        SettingsView()
    }
}

