//
//  Settings.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/24/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

class Settings {

    static let shared = Settings()
    private init() {}

    var isDebugModeEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.debugMode) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.debugMode) }
    }

    private enum Keys {
        static let debugMode = "DebugMode"
    }
}
