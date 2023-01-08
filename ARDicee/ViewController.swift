//
//  ViewController.swift
//  ARDicee
//
//  Created by JINSEOK on 2023/01/05.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return }
            let results = sceneView.session.raycast(query)
            
            guard let hitResult = results.first else { return }
            
            addDice(alLocation: hitResult)
            
            sceneView.autoenablesDefaultLighting = true
        }
    }
    
    func addDice(alLocation location: ARRaycastResult) {
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        guard let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) else {
            fatalError("Failed load SCNScene")
        }
        
        diceNode.position = SCNVector3(x: location.worldTransform.columns.3.x,
                                       y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                       z: location.worldTransform.columns.3.z)
        diceArray.append(diceNode)
        sceneView.scene.rootNode.addChildNode(diceNode)
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        let randonX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randonZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randonX * 5),
                                          y: 0,
                                          z: CGFloat(randonZ * 5),
                                          duration: 1))
    }
    
    @IBAction func rollDiceButtonTapped(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeDiceButtonTapped(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlane(with: planeAnchor)
        
        node.addChildNode(planeNode)
    }
    
    func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2 , 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        
        return planeNode
    }
}

