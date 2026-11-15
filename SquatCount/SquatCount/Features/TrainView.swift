import SwiftUI

struct TrainView: View {
    @State private var presentsSession = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
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
}
