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

    var opacity: Double {
        get { return UserDefaults.standard.double(forKey: Keys.opacity) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.opacity) }
    }

    var isRotationEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.rotation) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.rotation) }
    }

    var annotationVisibility: AnnotationVisibility {
        get { return AnnotationVisibility(rawValue: UserDefaults.standard.integer(forKey: Keys.annotations))! }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: Keys.annotations) }
    }


    enum AnnotationVisibility: Int {
        case visible
        case hover
        case hidden
    }

    private enum Keys {
        static let debugMode = "DebugMode"
        static let opacity = "Opacity"
        static let rotation = "Rotation"
        static let annotations = "Annotations"

    }
}
