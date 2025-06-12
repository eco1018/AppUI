//
//  InputType.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//


enum InputType: String, Codable {
    case binary     // Yes / No
    case scale      // 0 to 10
    case text       // Free-form string input (e.g. diary notes)
}