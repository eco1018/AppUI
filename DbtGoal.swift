//
//  DbtGoal.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//


import Foundation

/// Represents a DBT goal tracked with a Yes/No (binary) input
struct DbtGoal: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let inputType: InputType // Always `.binary` for goals

    // MARK: - Selectable Goals (User Chooses Up to 3)

    static var useSkill: DbtGoal {
        .init(id: "goal-use-skill", name: "Use a DBT Skill", inputType: .binary)
    }

    static var reachOut: DbtGoal {
        .init(id: "goal-reach-out", name: "Reach Out to Someone Supportive", inputType: .binary)
    }

    static var routine: DbtGoal {
        .init(id: "goal-routine", name: "Follow My Morning or Night Routine", inputType: .binary)
    }

    static var nourish: DbtGoal {
        .init(id: "goal-nourish", name: "Eat a Nourishing Meal", inputType: .binary)
    }

    static var move: DbtGoal {
        .init(id: "goal-move", name: "Move My Body (Stretch, Walk, etc.)", inputType: .binary)
    }

    static var getOutOfBed: DbtGoal {
        .init(id: "goal-bed", name: "Get Out of Bed", inputType: .binary)
    }

    static var selfCompassion: DbtGoal {
        .init(id: "goal-self-kindness", name: "Be Kind to Myself When I Struggle", inputType: .binary)
    }

    static var askForHelp: DbtGoal {
        .init(id: "goal-ask-help", name: "Ask for Help When I Need It", inputType: .binary)
    }

    static var justForMe: DbtGoal {
        .init(id: "goal-self-care", name: "Do Something Just for Me", inputType: .binary)
    }

    static var alignWithValues: DbtGoal {
        .init(id: "goal-values", name: "Do One Thing That Aligns with My Values", inputType: .binary)
    }

    static var selectableGoals: [DbtGoal] {
        [
            useSkill,
            reachOut,
            routine,
            nourish,
            move,
            getOutOfBed,
            selfCompassion,
            askForHelp,
            justForMe,
            alignWithValues
        ]
    }

    // MARK: - Custom Goals

    /// Use this method to create a custom goal entered by the user
    static func custom(id: String, name: String) -> DbtGoal {
        .init(id: id, name: name, inputType: .binary)
    }
}
