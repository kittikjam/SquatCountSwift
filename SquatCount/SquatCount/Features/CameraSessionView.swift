import SwiftUI
import UIKit

struct CameraSessionView: View {
    let configuration: ExerciseConfiguration

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @StateObject private var camera = CameraSessionController()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            CameraPreview(session: camera.session)
                .ignoresSafeArea()

            statusOverlay
            controlsOverlay
        }
        .task {
            camera.start()
        }
        .onDisappear {
            camera.stop()
        }
    }

    @ViewBuilder
    private var statusOverlay: some View {
        switch camera.status {
        case .idle, .requestingPermission:
            ProgressView()
                .tint(.white)

        case .ready:
            EmptyView()

        case .denied:
            VStack(spacing: 16) {
                Text("Camera access is required for workout tracking.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Button("Open Settings") {
                    guard let url = URL(
                        string: UIApplication.openSettingsURLString
                    ) else {
                        return
                    }

                    openURL(url)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()

        case .failed(let message):
            Text(message)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    private var controlsOverlay: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .padding(12)
                        .background(.black.opacity(0.6), in: Circle())
                }

                Spacer()

                Button {
                    camera.switchCamera()
                } label: {
                    Image(systemName: "camera.rotate")
                        .font(.headline)
                        .padding(12)
                        .background(.black.opacity(0.6), in: Circle())
                }
                .disabled(camera.status != .ready)
            }
            .foregroundStyle(.white)

            Spacer()

            Text(
                "\(configuration.variation.title) · "
                + "\(configuration.repetitionTarget) reps"
            )
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.black.opacity(0.6), in: Capsule())
        }
        .padding()
    }
}