import SwiftUI

struct CardView: View {
    let card: Card
    let language: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // "On Windows you did..."
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text(language == "ar" ? "في ويندوز كنت بتعمل..." : "On Windows you did...")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    } icon: {
                        Image(systemName: "window.shade.closed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text(card.windowsLabel(for: language))
                        .font(.subheadline)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .environment(\.layoutDirection, .leftToRight)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.primary.opacity(0.04))
                        )
                }

                // Arrow
                Image(systemName: "arrow.down")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .frame(maxWidth: .infinity)

                // "On Mac you do..."
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text(language == "ar" ? "على الماك بتعمل..." : "On Mac you do...")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color.accentColor)
                    } icon: {
                        Image(systemName: "apple.logo")
                            .font(.caption)
                            .foregroundStyle(Color.accentColor)
                    }

                    Text(card.macLabel(for: language))
                        .font(.subheadline.weight(.semibold))
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .environment(\.layoutDirection, .leftToRight)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.accentColor.opacity(0.08))
                        )
                }

                // Explanation
                Text(card.explanation(for: language))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)

                // Try it prompt
                if let prompt = card.tryItPrompt(for: language) {
                    HStack(spacing: 6) {
                        Image(systemName: "hand.point.up.left")
                            .font(.caption)
                        Text(prompt)
                            .font(.caption.weight(.medium))
                    }
                    .foregroundStyle(.orange)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.08))
                    )
                }
            }
            .padding(16)
        }
        .environment(\.layoutDirection, language == "ar" ? .rightToLeft : .leftToRight)
    }
}
