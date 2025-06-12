//
//  userUrges.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//
//

import Foundation

/// Describes how an urge or action input should be tracked in the app
enum InputType: String, Codable {
    case binary     // Yes / No — used for actions
    case scale      // 0 to 10 — used for urges
}

/// Represents a DBT urge (fixed, optional, or custom) for the user to track
struct DbtUrge: Identifiable, Codable, Hashable {
    let id: String           // Unique identifier (for Firestore, ML, etc.)
    let name: String         // What the user sees in the UI
    let inputType: InputType // Always `.scale` for urges

    // MARK: - Fixed Urges (Always Included for Every User)

    static var selfHarm: DbtUrge {
        .init(id: "self-harm", name: "Self Harm", inputType: .scale)
    }

    static var suicide: DbtUrge {
        .init(id: "suicide", name: "Suicidal Thoughts", inputType: .scale)
    }

    static var quitDbt: DbtUrge {
        .init(id: "quit-dbt", name: "Urge to Quit DBT", inputType: .scale)
    }

    // MARK: - Optional / Selectable Urges (User Can Choose Up To 2)

    static var isolate: DbtUrge {
        .init(id: "urge-isolate", name: "Urge to Isolate", inputType: .scale)
    }

    static var substances: DbtUrge {
        .init(id: "urge-substances", name: "Urge to Use Substances", inputType: .scale)
    }

    static var eating: DbtUrge {
        .init(id: "urge-eating", name: "Urge to Restrict/Eat Emotionally", inputType: .scale)
    }

    /// All optional urges offered during onboarding
    static var selectableUrges: [DbtUrge] {
        [isolate, substances, eating]
    }

    /// All required urges shown in the DiaryCard every day
    static var fixedUrges: [DbtUrge] {
        [selfHarm, suicide, quitDbt]
    }

    // MARK: - Custom User-Defined Urges

    /// Call this when the user writes their own urge during onboarding
    static func custom(id: String, name: String) -> DbtUrge {
        .init(id: id, name: name, inputType: .scale)
    }
}
