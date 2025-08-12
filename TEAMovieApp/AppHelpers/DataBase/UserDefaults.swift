//
//  UserDefaults.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//


import Foundation

extension UserDefaults {
    private enum Keys: String {
        case isFirstTime
    }

    @ModelsDefault(key: Keys.isFirstTime.rawValue, defaultValue: false)
    static var isFirstTime: Bool

}

