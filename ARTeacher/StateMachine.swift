//
//  StateMachine.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/9/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation

protocol StateMachineProtocol {

    func set<State: SceneState>(newState: State.Type)
}

class StateMachine: StateMachineProtocol {

    private let states: [SceneState]
    private var activeState: SceneState?

    init(states: [SceneState]) {
        self.states = states
    }

    func set<State: SceneState>(newState: State.Type) {
        let newStateObject = states.first { $0 is State }
        activeState?.didLeave()
        activeState = newStateObject
        newStateObject?.didEnter()
    }

    func updateFrame() {
        activeState?.updateFrame()
    }
}
