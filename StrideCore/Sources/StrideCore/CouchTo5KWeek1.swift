import Foundation

public enum CouchTo5KWeek1 {
    public static let plan: TrainingPlan = makePlan()

    private static func makePlan() -> TrainingPlan {
        do {
            let workouts = try (1...3).map(makeWorkout)
            let week = try TrainingWeek(
                id: TrainingWeekID("c25k.standard.v1.week.1"),
                number: 1,
                workouts: workouts
            )

            return try TrainingPlan(
                id: TrainingPlanID("c25k.standard"),
                version: 1,
                name: "Couch to 5K",
                weeks: [week]
            )
        } catch {
            preconditionFailure("The bundled Week 1 plan is invalid: \(error)")
        }
    }

    private static func makeWorkout(number: Int) throws -> Workout {
        let workoutPrefix = "c25k.standard.v1.week.1.workout.\(number)"
        var segments = [WorkoutSegment]()

        segments.append(
            try WorkoutSegment(
                id: WorkoutSegmentID("\(workoutPrefix).warm-up"),
                type: .warmUp,
                duration: .seconds(5 * 60)
            )
        )

        for repetition in 1...8 {
            segments.append(
                try WorkoutSegment(
                    id: WorkoutSegmentID("\(workoutPrefix).run.\(repetition)"),
                    type: .run,
                    duration: .seconds(60)
                )
            )
            segments.append(
                try WorkoutSegment(
                    id: WorkoutSegmentID("\(workoutPrefix).walk.\(repetition)"),
                    type: .walk,
                    duration: .seconds(90)
                )
            )
        }

        segments.append(
            try WorkoutSegment(
                id: WorkoutSegmentID("\(workoutPrefix).cool-down"),
                type: .coolDown,
                duration: .seconds(5 * 60)
            )
        )

        return try Workout(
            id: WorkoutID(workoutPrefix),
            number: number,
            name: "Week 1 Workout \(number)",
            segments: segments
        )
    }
}
