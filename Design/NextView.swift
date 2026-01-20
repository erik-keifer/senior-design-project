import SwiftUI

struct NextView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Next Screen")
                .font(.title2)
                .fontWeight(.semibold)

            Text("You successfully navigated here.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Next")
    }
}

#Preview {
    NavigationStack {
        NextView()
    }
}

