//
//
//  DbtMedicationCheckIn.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//

import Foundation

/// Represents a single Yes/No check-in for whether the user took their medications today
struct DbtMedicationCheckIn: Codable, Hashable {
    let id: String              // Unique ID per diary entry (or "today")
    let didTakeMeds: Bool       // true = Yes, false = No
    var inputType: InputType = .binary  // Made mutable to support decoding

    init(id: String = UUID().uuidString, didTakeMeds: Bool) {
        self.id = id
        self.didTakeMeds = didTakeMeds
    }
}
