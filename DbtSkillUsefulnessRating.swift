//
//  DbtSkillUsefulnessRating.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//

import Foundation

/// Represents a single 0–10 rating for overall skill usefulness on a given day
struct DbtSkillUsefulnessRating: Codable, Hashable {
    let id: String                  // Unique ID per diary entry (or "today")
    let score: Int                 // Rating from 0 to 10
    var inputType: InputType = .scale  // Marked mutable to support decoding

    init(id: String = UUID().uuidString, score: Int) {
        self.id = id
        self.score = score
    }
}
