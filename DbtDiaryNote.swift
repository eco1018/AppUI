//
//
//  DbtDiaryNote.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//

import Foundation

/// Represents a free-form daily diary note written by the user
struct DbtDiaryNote: Codable, Hashable {
    let id: String
    let text: String
    var inputType: InputType = .text  // made mutable to suppress Codable warning

    init(id: String = UUID().uuidString, text: String) {
        self.id = id
        self.text = text
    }
}
