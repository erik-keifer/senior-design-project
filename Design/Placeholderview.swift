import SwiftUI

struct PlaceholderView: View {
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text("Placeholder screen")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        PlaceholderView(title: "Insights")
    }
}



















