//
//  ObservingState.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/9/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import ARKit

protocol ObservingStateDelegate: class {
    func observingStateDidEnter(_ state: ObservingState)
    func observingStateDidLeave(_ state: ObservingState)
}

class ObservingState: SceneState {

    weak var delegate: ObservingStateDelegate?

    private let sceneView: ARSCNView
    private let object: SCNNode

    init(sceneView: ARSCNView, object: SCNNode) {
        self.sceneView = sceneView
        self.object = object
    }

    func didEnter() {
        object.opacity = 1.0
        delegate?.observingStateDidEnter(self)
    }

    func didLeave() {
        delegate?.observingStateDidLeave(self)
    }

    func updateFrame() {

    }
}
