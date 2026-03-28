import SwiftUI

struct LessonCard: View {
    let lesson: Lesson
    let language: String
    let isComplete: Bool
    let isInProgress: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: lesson.icon)
                    .font(.title3)
                    .foregroundStyle(isComplete ? .green : Color.accentColor)
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(lesson.title(for: language))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        if isComplete {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.caption)
                        } else if isInProgress {
                            Image(systemName: "circle.dotted")
                                .foregroundStyle(.orange)
                                .font(.caption)
                        }
                    }

                    Text(lesson.hook(for: language))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isComplete ? Color.green.opacity(0.05) : Color.primary.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
