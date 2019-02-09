//
//  SceneState.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/9/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

protocol SceneState {

    func didEnter()
    func didLeave()
    func updateFrame()
}
