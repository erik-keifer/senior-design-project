import SwiftUI

struct InsightsView: View {
    enum TimeRange: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        var id: String { rawValue }
    }

    @State private var timeRange: TimeRange = .week

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Custom header (Figma-style)
                Text("Insights")
                    .font(.title)
                    .fontWeight(.semibold)

                // Segmented control
                Picker("Time Range", selection: $timeRange) {
                    ForEach(TimeRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)

                // Chart placeholder (Figma-style block)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sleep Trend")
                        .font(.headline)

                    Text("Chart goes here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray5))
                        .frame(height: 180)
                }
                .padding(16)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)

                Text("")
                    .foregroundStyle(.secondary)

                Group {
                    switch timeRange {
                    case .week:
                        CardView(
                            title: "Weekly Summary",
                            description: "Overview of your recent trends.",
                            label: "Score",
                            value: "82"
                        )
                    case .month:
                        CardView(
                            title: "Monthly Summary",
                            description: "Month-level patterns in your trends.",
                            label: "Score",
                            value: "78"
                        )
                    case .year:
                        CardView(
                            title: "Yearly Summary",
                            description: "Long-term view of your trends.",
                            label: "Score",
                            value: "80"
                        )
                    }
                }
            }
            .padding(16)
        }
        .background(Color(uiColor: .systemGray6))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        InsightsView()
    }
}























































