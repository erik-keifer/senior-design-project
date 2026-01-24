import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack(spacing: 16) {

            Text("Chat")
                .font(.title)
                .fontWeight(.semibold)

            Text("This is where your chat UI will go.")
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Start Chat") {
                // later: open chat thread / start session
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .padding(.top, 24)
        .background(Color(uiColor: .systemGray6))
        .navigationTitle("Chat")
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}

