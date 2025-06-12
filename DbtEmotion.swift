//
//  DbtEmotion.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//

import Foundation

/// Represents a DBT emotion tracked daily on a 0–10 scale
struct DbtEmotion: Identifiable, Codable, Hashable {
    let id: String           // Unique identifier (for saving, ML, etc.)
    let name: String         // Display name shown to the user
    let inputType: InputType // Always `.scale` for emotions (0–10)

    // MARK: - Core DBT Emotions

    static var joy: DbtEmotion {
        .init(id: "emotion-joy", name: "Joy", inputType: .scale)
    }

    static var sadness: DbtEmotion {
        .init(id: "emotion-sadness", name: "Sadness", inputType: .scale)
    }

    static var anger: DbtEmotion {
        .init(id: "emotion-anger", name: "Anger", inputType: .scale)
    }

    static var anxiety: DbtEmotion {
        .init(id: "emotion-anxiety", name: "Anxiety", inputType: .scale)
    }

    static var shame: DbtEmotion {
        .init(id: "emotion-shame", name: "Shame", inputType: .scale)
    }

    static var connection: DbtEmotion {
        .init(id: "emotion-connection", name: "Connection", inputType: .scale)
    }

    // MARK: - Collection of All Core Emotions

    static var all: [DbtEmotion] {
        [joy, sadness, anger, anxiety, shame, connection]
    }
}
