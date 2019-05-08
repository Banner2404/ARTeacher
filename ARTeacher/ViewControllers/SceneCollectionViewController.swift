//
//  SceneCollectionViewController.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 2/14/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import UIKit
import SceneKit

class SceneCollectionViewController: UIViewController {

    var scenes: [Scene] = []
    let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttachment = TextAttachment(name: "Method", title: "Title", text: "Hello world")
        let webAttachment = WebAttachment(name: "Method", urlString: "https://en.wikipedia.org/wiki/Random-access_memory")

        let annotation1 = Annotation(title: "Roof", anchorId: "anchor1", attachments: [textAttachment, webAttachment])
        let annotation2 = Annotation(title: "Window", anchorId: "anchor2", attachments: [webAttachment])

        let tankAnnotation1 = Annotation(title: "Gun", anchorId: "anchor-gun", attachments: [])
        let tankAnnotation2 = Annotation(title: "Smoke Grenade", anchorId: "anchor-smoke", attachments: [])
        let tankAnnotation3 = Annotation(title: "Machine Gun", anchorId: "anchor-machinegun", attachments: [])

        let scene = Scene(name: "Test First", scenePath: "art.scnassets/Medieval_building.scn", annotations: [annotation1, annotation2])
        let shipScene = Scene(name: "Ship", scenePath: "art.scnassets/ship.scn", annotations: [])
        let tankScene = Scene(name: "Tank", scenePath: "laptop.scnassets/T-90.scn", annotations: [tankAnnotation1, tankAnnotation2, tankAnnotation3])

        let keyboardScene = Scene(name: "Keyboard", scenePath: "computer.scnassets/keyboard.scn", annotations: [])

        scenes = [scene, shipScene, tankScene, keyboardScene]
    }
}

// MARK: - UICollectionViewDataSource
extension SceneCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scenes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SceneCell", for: indexPath) as! SceneCollectionViewCell
        let scene = scenes[indexPath.row]
        cell.sceneLabel.text = scene.name
        sceneView.scene = SCNScene(named: scene.scenePath)
        sceneView.scene?.rootNode.eulerAngles.y = .pi / 3
        cell.sceneImageView.image = sceneView.snapshot()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SceneCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scene = scenes[indexPath.row]
        let vc: ARViewController = .loadFromStoryboard()
        vc.scene = scene
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
