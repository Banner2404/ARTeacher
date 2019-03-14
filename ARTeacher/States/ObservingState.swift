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

    func observingStateDidActivateAnnotation(_ state: ObservingState)
    func observingStateDidDeactivateAnnotation(_ state: ObservingState)

}

class ObservingState: SceneState {

    weak var delegate: ObservingStateDelegate?
    var activeAnnotation: Annotation? {
        return annotations.first { $0.anchorId == activatedAnchor?.name }
    }
    
    private let sceneView: ARSCNView
    private let object: SCNNode
    private let annotations: [Annotation]
    private var cursor: SCNNode!
    private lazy var popoverNode: SCNNode = createPopover()
    private lazy var popoverText: SCNText = createTextShape()
    private var activatedAnchor: SCNNode? {
        didSet {
            if activatedAnchor != nil {
                popoverNode.isHidden = false
                delegate?.observingStateDidActivateAnnotation(self)
            } else {
                popoverNode.isHidden = true
                delegate?.observingStateDidDeactivateAnnotation(self)
            }
        }
    }

    init(sceneView: ARSCNView, object: SCNNode, annotations: [Annotation]) {
        self.sceneView = sceneView
        self.object = object
        self.annotations = annotations
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
        let centerOfScreen = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        let hitTestResults = sceneView.hitTest(centerOfScreen, options: [.searchMode: SCNHitTestSearchMode.closest.rawValue,
                                                                         .categoryBitMask: 2])
        guard let hitTestResult = hitTestResults.first else {
            cursor.isHidden = true
            if activatedAnchor != nil {
                activatedAnchor?.opacity = 1.0
                activatedAnchor = nil
            }
            return
        }

        if activatedAnchor == nil || activatedAnchor !== hitTestResult.node {
            activatedAnchor = hitTestResult.node
            popoverText.string = activeAnnotation?.anchorId
            popoverNode.worldPosition = hitTestResult.node.worldPosition
            popoverNode.worldPosition.y += 0
            popoverNode.removeFromParentNode()
            sceneView.scene.rootNode.addChildNode(popoverNode)
            activatedAnchor?.opacity = 0.5
        }

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

    private func createPopover() -> SCNNode {
        let node = SCNNode(geometry: popoverText)
        node.constraints = [SCNBillboardConstraint()]
        node.isHidden = true
        node.renderingOrder = 1000
        node.scale = SCNVector3(0.04, 0.04, 0.04)
        sceneView.scene.rootNode.addChildNode(node)
        return node
    }

    func createTextShape() -> SCNText {
        let text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.materials.first?.diffuse.contents = UIColor.white
        text.materials.first?.readsFromDepthBuffer = false
        text.materials.first?.writesToDepthBuffer = false
        return text
    }


}
