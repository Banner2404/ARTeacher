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

class ARViewController: UIViewController {

    var scene: Scene!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var placeObjectButton: UIButton!
    @IBOutlet weak var arrangeButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    private var object: SCNNode!
    private var stateMachine: StateMachine!
    private var annotations: [Annotation] {
        return scene.annotations
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObject()
        setupStateMachine()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        updateDebugMode()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDebugMode), name: UserDefaults.didChangeNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItem()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration, options: [])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreNavigationItem()
        sceneView.session.pause()
    }

    @objc
    func updateDebugMode() {
        sceneView.showsStatistics = Settings.shared.isDebugModeEnabled
        sceneView.debugOptions = Settings.shared.isDebugModeEnabled ? [.showFeaturePoints] : []
    }
    
    @IBAction func placeObjectTap(_ sender: Any) {
        stateMachine.set(newState: ObservingState.self)
    }
    
    @IBAction func arrangeButtonTap(_ sender: Any) {
        stateMachine.set(newState: PlacementState.self)
    }

    @IBAction func viewButtonTap(_ sender: Any) {
        guard let annotation = stateMachine.activeAnnotation else { return }
        let viewController: AttachmentsTableViewController = .loadFromStoryboard()
        viewController.annotation = annotation
        let navc = UINavigationController(rootViewController: viewController)
        navc.modalPresentationStyle = .pageSheet
        present(navc, animated: true, completion: nil)
    }

    @IBAction private func sceneRotate(_ sender: UIRotationGestureRecognizer) {
        guard let object = object else { return }
        object.eulerAngles.y -= Float(sender.rotation)
        sender.rotation = 0
    }

    @IBAction private func sceneZoom(_ sender: UIPinchGestureRecognizer) {
        guard let object = object else { return }
        object.scale.x *= Float(sender.scale)
        object.scale.y *= Float(sender.scale)
        object.scale.z *= Float(sender.scale)

        sender.scale = 1
    }

    private func setupStateMachine() {
        let placementState = PlacementState(sceneView: sceneView, object: object)
        placementState.delegate = self
        let observingState = ObservingState(sceneView: sceneView, object: object, annotations: annotations)
        observingState.delegate = self
        stateMachine = StateMachine(states: [placementState, observingState])
        stateMachine.set(newState: PlacementState.self)
    }

    private func setupObject() {
        guard let node = loadObjectNode() else {
            print("Can't load object node")
            return
        }
        node.isHidden = true
        self.object = node
        sceneView.scene.rootNode.addChildNode(node)
    }

    private func loadObjectNode() -> SCNNode? {
        return SCNScene(named: scene.scenePath)?.rootNode
    }

    private func setupNavigationItem() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.clear

    }

    private func restoreNavigationItem() {
        navigationController?.navigationBar.shadowImage = nil
    }
}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {

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
extension ARViewController: ARSessionDelegate {

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        stateMachine.updateFrame()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ARViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - PlacementStateDelegate
extension ARViewController: PlacementStateDelegate {

    func placementStateDidEnter(_ state: PlacementState) {
        placeObjectButton.isHidden = false
    }

    func placementStateDidLeave(_ state: PlacementState) {
        placeObjectButton.isHidden = true
    }

    func placementStateDidActivateButton(_ state: PlacementState) {
        placeObjectButton.isEnabled = true
        placeObjectButton.alpha = 1.0
    }

    func placementStateDidDeactivateButton(_ state: PlacementState) {
        placeObjectButton.isEnabled = false
        placeObjectButton.alpha = 0.5
    }
}

// MARK: - ObservingStateDelegate
extension ARViewController: ObservingStateDelegate {

    func observingStateDidEnter(_ state: ObservingState) {
        arrangeButton.isHidden = false
        viewButton.isHidden = false
        observingStateDidDeactivateAnnotation(state)
    }

    func observingStateDidLeave(_ state: ObservingState) {
        arrangeButton.isHidden = true
        viewButton.isHidden = true
    }

    func observingStateDidActivateAnnotation(_ state: ObservingState) {
        viewButton.isEnabled = true
        viewButton.alpha = 1.0
    }

    func observingStateDidDeactivateAnnotation(_ state: ObservingState) {
        viewButton.isEnabled = false
        viewButton.alpha = 0.5
    }
}
