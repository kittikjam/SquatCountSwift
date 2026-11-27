import AVFoundation
import Combine

final class CameraSessionController: ObservableObject {
    enum Status: Equatable {
        case idle
        case requestingPermission
        case ready
        case denied
        case failed(String)
    }

    let session = AVCaptureSession()

    @Published private(set) var status: Status = .idle
    @Published private(set) var cameraPosition: AVCaptureDevice.Position = .back

    private let sessionQueue = DispatchQueue(
        label: "com.squatcount.camera-session"
    )

    private var currentInput: AVCaptureDeviceInput?
    private var isConfigured = false

    func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureAndStart()

        case .notDetermined:
            publish(.requestingPermission)

            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }

                if granted {
                    self.configureAndStart()
                } else {
                    self.publish(.denied)
                }
            }

        case .denied, .restricted:
            publish(.denied)

        @unknown default:
            publish(.failed("Unknown camera permission state."))
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            if self.session.isRunning {
                self.session.stopRunning()
            }

            self.publish(.idle)
        }
    }

    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard
                let self,
                self.isConfigured,
                let currentInput = self.currentInput
            else {
                return
            }

            let newPosition: AVCaptureDevice.Position =
                self.cameraPosition == .back ? .front : .back

            guard let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: newPosition
            ) else {
                return
            }

            do {
                let newInput = try AVCaptureDeviceInput(device: device)

                self.session.beginConfiguration()
                self.session.removeInput(currentInput)

                if self.session.canAddInput(newInput) {
                    self.session.addInput(newInput)
                    self.currentInput = newInput
                    self.session.commitConfiguration()

                    DispatchQueue.main.async {
                        self.cameraPosition = newPosition
                    }
                } else {
                    // Restore the previous input if the replacement fails.
                    if self.session.canAddInput(currentInput) {
                        self.session.addInput(currentInput)
                    }

                    self.session.commitConfiguration()
                    self.publish(.failed("Unable to switch cameras."))
                }
            } catch {
                self.publish(.failed(error.localizedDescription))
            }
        }
    }

    private func configureAndStart() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            do {
                if !self.isConfigured {
                    try self.configureSession()
                }

                if !self.session.isRunning {
                    self.session.startRunning()
                }

                self.publish(.ready)
            } catch {
                self.publish(.failed(error.localizedDescription))
            }
        }
    }

    private func configureSession() throws {
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: cameraPosition
        ) else {
            throw CameraSetupError.cameraUnavailable
        }

        let input = try AVCaptureDeviceInput(device: camera)

        guard session.canAddInput(input) else {
            throw CameraSetupError.cannotAddInput
        }

        session.addInput(input)
        currentInput = input
        isConfigured = true
    }

    private func publish(_ status: Status) {
        DispatchQueue.main.async { [weak self] in
            self?.status = status
        }
    }
}

private enum CameraSetupError: LocalizedError {
    case cameraUnavailable
    case cannotAddInput

    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            "No suitable camera is available."
        case .cannotAddInput:
            "The camera could not be added to the capture session."
        }
    }
}