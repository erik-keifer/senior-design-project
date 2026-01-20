import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail View")
                .font(.title)
                .fontWeight(.semibold)

            Text("This screen was pushed from Home.")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}

#Preview {
    NavigationStack {
        DetailView()
    }
}



















