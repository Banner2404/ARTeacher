//
//  ViewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 1/13/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var cursor: SCNNode?
    var ship: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration, options: [])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @IBAction private func scheneTap(_ sender: UITapGestureRecognizer) {
        if ship != nil {
            detectCollision(sender)
            return
        }
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: [.existingPlaneUsingExtent])

        guard let hitTestResult = hitTestResults.first else { return }
        let x = hitTestResult.worldTransform.columns.3.x
        let y = hitTestResult.worldTransform.columns.3.y
        let z = hitTestResult.worldTransform.columns.3.z

        guard let scene = SCNScene(named: "art.scnassets/Medieval_building.scn") else { return }
        let planeNode = scene.rootNode
        planeNode.position = SCNVector3(x: x, y: y, z: z)
        sceneView.scene.rootNode.addChildNode(planeNode)
        ship = planeNode
    }

    @IBAction private func sceneRotate(_ sender: UIRotationGestureRecognizer) {
        guard let ship = ship else { return }
        ship.eulerAngles.y -= Float(sender.rotation)
        sender.rotation = 0
    }

    @IBAction private func sceneZoom(_ sender: UIPinchGestureRecognizer) {
        guard let ship = ship else { return }
        ship.scale.x *= Float(sender.scale)
        ship.scale.y *= Float(sender.scale)
        ship.scale.z *= Float(sender.scale)

        sender.scale = 1
    }

    private func detectCollision(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, options: [.searchMode: SCNHitTestSearchMode.closest.rawValue])
        print(hitTestResults.map { $0.node.name })
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {

    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session interruption ended")
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session failed", error.localizedDescription)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)

        plane.materials.first?.diffuse.contents = UIColor.red.withAlphaComponent(0.3)
        let planeNode = SCNNode(geometry: plane)
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        planeNode.eulerAngles.x = -.pi / 2

        node.addChildNode(planeNode)

    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard let planeNode = node.childNodes.first else { return }
        guard let plane = planeNode.geometry as? SCNPlane else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height

        planeNode.simdPosition = planeAnchor.center
    }
}

// MARK: - ARSessionDelegate
extension ViewController: ARSessionDelegate {

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let tapLocation = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        let hitTestResults = sceneView.hitTest(tapLocation, types: [.existingPlaneUsingExtent])

        guard let hitTestResult = hitTestResults.first else {
            cursor?.removeFromParentNode()
            cursor = nil
            return
        }
        let x = hitTestResult.worldTransform.columns.3.x
        let y = hitTestResult.worldTransform.columns.3.y
        let z = hitTestResult.worldTransform.columns.3.z

        if cursor == nil {
            let ball = SCNSphere(radius: 0.01)
            ball.materials.first?.diffuse.contents = UIColor.white
            cursor = SCNNode(geometry: ball)
            sceneView.scene.rootNode.addChildNode(cursor!)
        }
        cursor?.position = SCNVector3(x: x, y: y, z: z)
    }
}
