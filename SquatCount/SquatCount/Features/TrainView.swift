import SwiftUI

struct TrainView: View {
    @State private var presentsSession = false
    @State private var kneeTarget = 90.0
    @State private var tolerance = 5.0
    @State private var linksSides = true
    @State private var assessmentMode = 0
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    targetArtwork
                    variationSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(AppTheme.canvas.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $presentsSession) {
                Text("Workout session")
                    .sheetTitle()
                    .padding()
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
        Text("PERSONAL DEPTH  ≤ \(kneeTarget, specifier: "%.0f")°")
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
                HStack(spacing: 12) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(AppTheme.accent)

                    Text("Squat")
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.ink)

                    Spacer()

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
