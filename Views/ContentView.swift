import SwiftUI

struct ContentView: View {
    @State private var goNext = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header (closer to your Figma)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sleep Focus")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Saturday, January 17")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                // Card → pushes DetailView
                NavigationLink {
                    DetailView()
                } label: {
                    CardView(
                        title: "Sleep Quality",
                        description: "Great sleep last night",
                        label: "",
                        value: "8.2/10"
                    )
                }
                .buttonStyle(.plain)

                // Second card → pushes InsightsView
                NavigationLink {
                    InsightsView()
                } label: {
                    CardView(
                        title: "Focus Prediction",
                        description: "Focus windows throughout the day",
                        label: "",
                        value: "View"
                    )
                }
                .buttonStyle(.plain)

                // Continue button → pushes NextView
                PrimaryButton(title: "Continue") {
                    goNext = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .background(Color(uiColor: .systemGray6))
        .navigationTitle("")                 // removes the big nav title
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $goNext) {
            NextView()
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}














