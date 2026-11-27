import Foundation

enum ExerciseVariation: String, CaseIterable, Identifiable {
    case squat = "Squat"
    case gobletSquat = "Goblet squat"
    case sumoSquat = "Sumo squat"
    case splitSquat = "Split squat"

    var id: String { rawValue }

    var title: String { rawValue }
}

struct ExerciseConfiguration: Equatable {
    var variation: ExerciseVariation
    var leftKneeTarget: Double
    var rightKneeTarget: Double
    var targetsLinked: Bool
    var tolerance: Double
    var repetitionTarget: Int

    static let initial = ExerciseConfiguration(
        variation: .squat,
        leftKneeTarget: 90,
        rightKneeTarget: 90,
        targetsLinked: true,
        tolerance: 5,
        repetitionTarget: 10
    )

    mutating func setTargetsLinked(_ isLinked: Bool) {
        targetsLinked = isLinked

        if isLinked {
            rightKneeTarget = leftKneeTarget
        }
    }

    mutating func setLeftKneeTarget(_ target: Double) {
        leftKneeTarget = target

        if targetsLinked {
            rightKneeTarget = target
        }
    }
}
