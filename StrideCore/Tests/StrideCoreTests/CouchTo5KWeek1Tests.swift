import Foundation
import Testing
@testable import StrideCore

struct CouchTo5KWeek1Tests {
    private let plan = CouchTo5KWeek1.plan

    @Test func weekOneContainsThreeWorkouts() {
        #expect(plan.weeks.count == 1)
        #expect(plan.weeks[0].workouts.count == 3)
    }

    @Test func everyWorkoutHasTheExpectedSegmentSequence() {
        let expectedTypes: [SegmentType] = [
            .warmUp,
            .run, .walk,
            .run, .walk,
            .run, .walk,
            .run, .walk,
            .run, .walk,
            .run, .walk,
            .run, .walk,
            .run, .walk,
            .coolDown,
        ]

        for workout in plan.weeks[0].workouts {
            #expect(workout.segments.map(\.type) == expectedTypes)
        }
    }

    @Test func everyWorkoutHasEightRunsAndEightRecoveryWalks() {
        for workout in plan.weeks[0].workouts {
            #expect(workout.segments.count { $0.type == .run } == 8)
            #expect(workout.segments.count { $0.type == .walk } == 8)
        }
    }

    @Test func everySegmentHasTheExpectedDuration() {
        for workout in plan.weeks[0].workouts {
            #expect(workout.segments.first?.duration == .seconds(300))
            #expect(workout.segments.last?.duration == .seconds(300))

            for segment in workout.segments where segment.type == .run {
                #expect(segment.duration == .seconds(60))
            }
            for segment in workout.segments where segment.type == .walk {
                #expect(segment.duration == .seconds(90))
            }
        }
    }

    @Test func calculatedWorkoutDurationIsThirtyMinutes() {
        for workout in plan.weeks[0].workouts {
            #expect(workout.duration == .seconds(30 * 60))
        }
    }

    @Test func identifiersAreStable() {
        #expect(plan.id.rawValue == "c25k.standard")
        #expect(plan.version == 1)
        #expect(plan.weeks[0].id.rawValue == "c25k.standard.v1.week.1")
        #expect(
            plan.weeks[0].workouts.map(\.id.rawValue) == [
                "c25k.standard.v1.week.1.workout.1",
                "c25k.standard.v1.week.1.workout.2",
                "c25k.standard.v1.week.1.workout.3",
            ]
        )
    }

    @Test func identifiersAreUniqueAcrossWeekOne() {
        let workouts = plan.weeks[0].workouts
        let workoutIDs = workouts.map(\.id)
        let segmentIDs = workouts.flatMap(\.segments).map(\.id)

        #expect(Set(workoutIDs).count == workoutIDs.count)
        #expect(Set(segmentIDs).count == segmentIDs.count)
    }

    @Test(arguments: [Duration.zero, .seconds(-1)])
    func zeroAndNegativeDurationsAreRejected(duration: Duration) throws {
        let id = try WorkoutSegmentID("test.segment")

        #expect(throws: ModelValidationError.invalidSegmentDuration(duration)) {
            try WorkoutSegment(id: id, type: .run, duration: duration)
        }
    }
}
