//
//  DbtAction.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//


//
//  UserActions.swift
//  aura
//
//  Created by [Your Name] on [Today’s Date].
//

import Foundation

/// Represents a DBT action tracked with a Yes/No (binary) input
struct DbtAction: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let inputType: InputType // Always `.binary` for actions

    // MARK: - Fixed Actions (Always Included)

    static var selfHarm: DbtAction {
        .init(id: "action-self-harm", name: "Self Harm", inputType: .binary)
    }

    static var suicide: DbtAction {
        .init(id: "action-suicide", name: "Suicide Attempt", inputType: .binary)
    }

    static var fixedActions: [DbtAction] {
        [selfHarm, suicide]
    }

    // MARK: - Optional/Selectable Actions (User Can Choose 0–3)

    static var substanceUse: DbtAction {
        .init(id: "action-substance", name: "Substance Use", inputType: .binary)
    }

    static var disorderedEating: DbtAction {
        .init(id: "action-eating", name: "Disordered Eating", inputType: .binary)
    }

    static var lashingOut: DbtAction {
        .init(id: "action-lashing-out", name: "Lashing Out at Others", inputType: .binary)
    }

    static var withdrawal: DbtAction {
        .init(id: "action-withdrawal", name: "Withdrawing from People", inputType: .binary)
    }

    static var riskySex: DbtAction {
        .init(id: "action-risky-sex", name: "Risky Sexual Behavior", inputType: .binary)
    }

    static var overspending: DbtAction {
        .init(id: "action-overspending", name: "Overspending or Impulsive Shopping", inputType: .binary)
    }

    static var selfNeglect: DbtAction {
        .init(id: "action-self-neglect", name: "Self-Neglect", inputType: .binary)
    }

    static var avoidingResponsibilities: DbtAction {
        .init(id: "action-avoidance", name: "Avoiding Responsibilities", inputType: .binary)
    }

    static var breakingRules: DbtAction {
        .init(id: "action-breaking-rules", name: "Breaking Rules or the Law", inputType: .binary)
    }

    static var selectableActions: [DbtAction] {
        [
            substanceUse,
            disorderedEating,
            lashingOut,
            withdrawal,
            riskySex,
            overspending,
            selfNeglect,
            avoidingResponsibilities,
            breakingRules
        ]
    }

    // MARK: - Custom Actions

    /// Allows creation of user-defined custom actions
    static func custom(id: String, name: String) -> DbtAction {
        .init(id: id, name: name, inputType: .binary)
    }
}