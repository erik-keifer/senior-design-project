import SwiftUI

struct CardView: View {
    let title: String
    let description: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Title
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            // Description
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Footer row (optional label)
            HStack {
                if !label.isEmpty {
                    Text(label)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(value)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())        // entire card tappable
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }
}

#Preview {
    CardView(
        title: "Sleep Quality",
        description: "Great sleep last night",
        label: "",
        value: "8.2 / 10"
    )
    .padding()
    .background(Color(uiColor: .systemGray6))
}
























































