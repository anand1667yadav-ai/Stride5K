import Foundation

public enum ModelValidationError: Error, Equatable {
    case emptyName
    case emptyWeeks
    case emptyWorkouts
    case emptySegments
    case invalidPlanVersion(Int)
    case invalidWeekNumber(Int)
    case invalidWorkoutNumber(Int)
    case invalidSegmentDuration(Duration)
    case duplicateWeekID(TrainingWeekID)
    case duplicateWeekNumber(Int)
    case duplicateWorkoutID(WorkoutID)
    case duplicateWorkoutNumber(Int)
    case duplicateSegmentID(WorkoutSegmentID)
}

public struct TrainingPlan: Codable, Equatable, Identifiable, Sendable {
    public let id: TrainingPlanID
    public let version: Int
    public let name: String
    public let weeks: [TrainingWeek]

    public init(
        id: TrainingPlanID,
        version: Int,
        name: String,
        weeks: [TrainingWeek]
    ) throws {
        guard version > 0 else {
            throw ModelValidationError.invalidPlanVersion(version)
        }
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ModelValidationError.emptyName
        }
        guard !weeks.isEmpty else {
            throw ModelValidationError.emptyWeeks
        }
        if let duplicate = weeks.firstDuplicate(of: \TrainingWeek.id) {
            throw ModelValidationError.duplicateWeekID(duplicate)
        }
        if let duplicate = weeks.firstDuplicate(of: \TrainingWeek.number) {
            throw ModelValidationError.duplicateWeekNumber(duplicate)
        }

        self.id = id
        self.version = version
        self.name = name
        self.weeks = weeks
    }
}

public struct TrainingWeek: Codable, Equatable, Identifiable, Sendable {
    public let id: TrainingWeekID
    public let number: Int
    public let workouts: [Workout]

    public init(id: TrainingWeekID, number: Int, workouts: [Workout]) throws {
        guard number > 0 else {
            throw ModelValidationError.invalidWeekNumber(number)
        }
        guard !workouts.isEmpty else {
            throw ModelValidationError.emptyWorkouts
        }
        if let duplicate = workouts.firstDuplicate(of: \Workout.id) {
            throw ModelValidationError.duplicateWorkoutID(duplicate)
        }
        if let duplicate = workouts.firstDuplicate(of: \Workout.number) {
            throw ModelValidationError.duplicateWorkoutNumber(duplicate)
        }

        self.id = id
        self.number = number
        self.workouts = workouts
    }
}

public struct Workout: Codable, Equatable, Identifiable, Sendable {
    public let id: WorkoutID
    public let number: Int
    public let name: String
    public let segments: [WorkoutSegment]

    public var duration: Duration {
        segments.reduce(.zero) { $0 + $1.duration }
    }

    public init(
        id: WorkoutID,
        number: Int,
        name: String,
        segments: [WorkoutSegment]
    ) throws {
        guard number > 0 else {
            throw ModelValidationError.invalidWorkoutNumber(number)
        }
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ModelValidationError.emptyName
        }
        guard !segments.isEmpty else {
            throw ModelValidationError.emptySegments
        }
        if let duplicate = segments.firstDuplicate(of: \WorkoutSegment.id) {
            throw ModelValidationError.duplicateSegmentID(duplicate)
        }

        self.id = id
        self.number = number
        self.name = name
        self.segments = segments
    }
}

public struct WorkoutSegment: Codable, Equatable, Identifiable, Sendable {
    public let id: WorkoutSegmentID
    public let type: SegmentType
    public let duration: Duration

    public init(
        id: WorkoutSegmentID,
        type: SegmentType,
        duration: Duration
    ) throws {
        guard duration > .zero else {
            throw ModelValidationError.invalidSegmentDuration(duration)
        }

        self.id = id
        self.type = type
        self.duration = duration
    }
}

public enum SegmentType: String, Codable, CaseIterable, Sendable {
    case warmUp
    case run
    case walk
    case coolDown
}

private extension Collection {
    func firstDuplicate<Value: Hashable>(of keyPath: KeyPath<Element, Value>) -> Value? {
        var seen = Set<Value>()

        for element in self {
            let value = element[keyPath: keyPath]
            if !seen.insert(value).inserted {
                return value
            }
        }

        return nil
    }
}
