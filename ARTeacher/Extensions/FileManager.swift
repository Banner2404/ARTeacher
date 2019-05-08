//
//  FileManager.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 5/8/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

extension FileManager {

    var applicationSupport: URL {
        return try! url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
