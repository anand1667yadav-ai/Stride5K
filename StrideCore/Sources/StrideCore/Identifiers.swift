import Foundation

public protocol StableIdentifier: Codable, Hashable, Sendable {
    var rawValue: String { get }
}

public enum IdentifierValidationError: Error, Equatable {
    case empty
}

private func validate(_ rawValue: String) throws -> String {
    guard !rawValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        throw IdentifierValidationError.empty
    }

    return rawValue
}

public struct TrainingPlanID: StableIdentifier {
    public let rawValue: String

    public init(_ rawValue: String) throws {
        self.rawValue = try validate(rawValue)
    }
}

public struct TrainingWeekID: StableIdentifier {
    public let rawValue: String

    public init(_ rawValue: String) throws {
        self.rawValue = try validate(rawValue)
    }
}

public struct WorkoutID: StableIdentifier {
    public let rawValue: String

    public init(_ rawValue: String) throws {
        self.rawValue = try validate(rawValue)
    }
}

public struct WorkoutSegmentID: StableIdentifier {
    public let rawValue: String

    public init(_ rawValue: String) throws {
        self.rawValue = try validate(rawValue)
    }
}
