//
//  DbtMedicationCheckIn.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//


//
//  UserMedications.swift
//  aura
//
//  Created by [Your Name] on [Today’s Date].
//

import Foundation

/// Represents a single Yes/No check-in for whether the user took their medications today
struct DbtMedicationCheckIn: Codable, Hashable {
    let id: String              // Unique ID per diary entry (or "today")
    let didTakeMeds: Bool       // true = Yes, false = No
    let inputType: InputType = .binary

    init(id: String = UUID().uuidString, didTakeMeds: Bool) {
        self.id = id
        self.didTakeMeds = didTakeMeds
    }
}