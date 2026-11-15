import SwiftUI

struct ProfileView: View {
    @State private var workoutDisplay: WorkoutDisplayMode = .guided

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    workoutDisplaySection
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(AppTheme.canvas.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PROFILE")
                .sectionLabel()

            Text("Profile Management.")
                .displayTitle()
        }
    }

    private var workoutDisplaySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Workout display")
                .sectionLabel()

            SurfaceCard {
                ForEach(WorkoutDisplayMode.allCases) { mode in
                    if mode != WorkoutDisplayMode.minimal {
                        Divider()
                            .padding(.vertical, 12)
                    }

                    Button {
                        workoutDisplay = mode
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(
                                systemName: workoutDisplay == mode
                                    ? "circle.inset.filled"
                                    : "circle"
                            )
                            .font(.system(size: 20))
                            .foregroundColor(
                                workoutDisplay == mode
                                    ? AppTheme.accent
                                    : AppTheme.secondaryInk
                            )
                            .padding(.top, 1)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(mode.title)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.ink)

                                Text(mode.description)
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.secondaryInk)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(
                        workoutDisplay == mode ? .isSelected : []
                    )
                }
            }
        }
    }
}

private enum WorkoutDisplayMode: String, CaseIterable, Identifiable {
    case minimal
    case guided
    case analysis

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var description: String {
        switch self {
        case .minimal:
            "Displays only the camera, rep count and tracking."
        case .guided:
            "Adds personalised feedback to the workout display."
        case .analysis:
            "Shows live angles, movement phase and rating."
        }
    }
}
