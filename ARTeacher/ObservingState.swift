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
    private var cursor: SCNNode!
    private var activatedAnchor: SCNNode?

    init(sceneView: ARSCNView, object: SCNNode) {
        self.sceneView = sceneView
        self.object = object
    }

    func didEnter() {
        object.opacity = 1.0
        cursor = createCursor()
        delegate?.observingStateDidEnter(self)
    }

    func didLeave() {
        cursor.removeFromParentNode()
        delegate?.observingStateDidLeave(self)
    }

    func updateFrame() {
        activatedAnchor?.opacity = 1.0
        activatedAnchor = nil
        let centerOfScreen = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        let hitTestResults = sceneView.hitTest(centerOfScreen, options: [.searchMode: SCNHitTestSearchMode.closest.rawValue,
                                                                         .categoryBitMask: 2])
        guard let hitTestResult = hitTestResults.first else {
            cursor.isHidden = true
            return
        }
        activatedAnchor = hitTestResult.node
        activatedAnchor?.opacity = 0.5

        let x = hitTestResult.worldCoordinates.x
        let y = hitTestResult.worldCoordinates.y
        let z = hitTestResult.worldCoordinates.z

        cursor.position = SCNVector3(x: x, y: y, z: z)
        cursor.isHidden = false
    }

    private func createCursor() -> SCNNode {
        let ball = SCNSphere(radius: 0.01)
        ball.materials.first?.diffuse.contents = UIColor.white
        let cursor = SCNNode(geometry: ball)
        sceneView.scene.rootNode.addChildNode(cursor)
        return cursor
    }
}
