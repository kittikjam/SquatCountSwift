import SwiftUI

struct TrainView: View {
    @State private var presentsSession = false
    @State private var configuration = ExerciseConfiguration.initial

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    targetArtwork
                    variationSection
                    targetSection
                    startButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(AppTheme.canvas.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .fullScreenCover(isPresented: $presentsSession) {
                CameraSessionView(configuration: configuration)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FORM / SQUAT")
                .sectionLabel()

            Text("Train to your\nrange.")
                .displayTitle()

            Text("Set a personal target, then use the camera for live movement feedback.")
                .bodyCopy()
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var targetArtwork: some View {
        Text("PERSONAL DEPTH  ≤ \(configuration.leftKneeTarget, specifier: "%.0f")°")
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .tracking(0.5)
            .foregroundColor(AppTheme.ink)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Color.white,
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppTheme.line, lineWidth: 1)
            }
    }

    private var variationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Exercise variation")
                .sectionLabel()

            SurfaceCard {
                Menu {
                    ForEach(ExerciseVariation.allCases) { variation in
                        Button {
                            configuration.variation = variation
                        } label: {
                            Text(variation.title)
                        }
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .foregroundColor(AppTheme.accent)

                        Text(configuration.variation.title)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.ink)

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var targetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your target")
                    .sectionLabel()

                Spacer()

                Toggle(
                    "Link sides",
                    isOn: Binding(
                        get: { configuration.targetsLinked },
                        set: { isLinked in
                            configuration.setTargetsLinked(isLinked)
                        }
                    )
                )
                .font(.subheadline)
                .fontWeight(.medium)
                .fixedSize()
                .tint(AppTheme.accent)
            }

            SurfaceCard {
                AngleSlider(
                    title: "Left knee target",
                    value: Binding(
                        get: { configuration.leftKneeTarget },
                        set: { newTarget in
                            configuration.setLeftKneeTarget(newTarget)
                        }
                    )
                )

                if !configuration.targetsLinked {
                    Divider()
                        .padding(.vertical, 8)

                    AngleSlider(
                        title: "Right knee target",
                        value: $configuration.rightKneeTarget
                    )
                }

                Divider()
                    .padding(.vertical, 8)

                VStack(spacing: 6) {
                    HStack {
                        Label("Permitted tolerance", systemImage: "slider.horizontal.3")
                        Spacer()
                        Text("±\(configuration.tolerance, specifier: "%.0f")°")
                            .fontWeight(.bold)
                    }

                    Slider(value: $configuration.tolerance, in: 0...15, step: 1)
                        .tint(AppTheme.accent)
                }

                Divider()
                    .padding(.vertical, 8)

                HStack {
                    Label("Repetition target", systemImage: "repeat")
                    Spacer()
                    Picker("Repetitions", selection: $configuration.repetitionTarget) {
                        ForEach([5, 8, 10, 12, 15, 20], id: \.self) { count in
                            Text("\(count) reps")
                                .tag(count)
                        }
                    }
                    .labelsHidden()
                }
            }
        }
    }

    private var startButton: some View {
        Button {
            presentsSession = true
        } label: {
            HStack {
                Text("Start session")
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .frame(height: 58)
            .background(AppTheme.ink)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

private struct AngleSlider: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Label(title, systemImage: "angle")
                Spacer()
                Text("≤ \(value, specifier: "%.0f")°")
                    .fontWeight(.bold)
            }

            Slider(value: $value, in: 70...165, step: 5)
                .tint(AppTheme.accent)
        }
    }
}
