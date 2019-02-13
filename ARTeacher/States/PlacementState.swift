//
//  PlacementState.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/9/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import ARKit

protocol PlacementStateDelegate: class {
    func placementStateDidEnter(_ state: PlacementState)
    func placementStateDidLeave(_ state: PlacementState)
    func placementStateDidActivateButton(_ state: PlacementState)
    func placementStateDidDeactivateButton(_ state: PlacementState)
}

class PlacementState: SceneState {

    weak var delegate: PlacementStateDelegate?

    var activeAnnotation: Annotation? = nil

    private let sceneView: ARSCNView
    private let object: SCNNode

    init(sceneView: ARSCNView, object: SCNNode) {
        self.sceneView = sceneView
        self.object = object
    }

    func didEnter() {
        object.opacity = 0.5
        delegate?.placementStateDidEnter(self)
    }

    func didLeave() {
        delegate?.placementStateDidLeave(self)
    }

    func updateFrame() {
        let centerOfScreen = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        let hitTestResults = sceneView.hitTest(centerOfScreen, types: [.existingPlaneUsingExtent])

        guard let hitTestResult = hitTestResults.first else {
            delegate?.placementStateDidDeactivateButton(self)
            object.isHidden = true
            return
        }
        let x = hitTestResult.worldTransform.columns.3.x
        let y = hitTestResult.worldTransform.columns.3.y
        let z = hitTestResult.worldTransform.columns.3.z

        object.position = SCNVector3(x: x, y: y, z: z)
        object.isHidden = false
        delegate?.placementStateDidActivateButton(self)
    }
}
