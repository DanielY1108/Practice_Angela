//
//  ViewController.swift
//  ARRuler
//
//  Created by JINSEOK on 2023/01/09.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // 점으로 무슨일 일어는지 표현
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // 터치되는 위치 얻기
        let touchLocation = touch.location(in: sceneView)
        
        // 2D공간(화면)을 3D로 좌표를 계산하여 변환시켜 준다.
        guard let query = sceneView.raycastQuery(from: touchLocation,
                                                 allowing: .estimatedPlane,
                                                 alignment: .any) else { return }
        
        // 터치시 3D공간의 위치 정보 결과들
        let hitResults = sceneView.session.raycast(query)
        
        // 터치시 3D공간의 위치결과
        guard let hitResult = hitResults.first else { return }
    
        addDot(at: hitResult)
    }
    
    func addDot(at location: ARRaycastResult) {
        
        let dotGeometry = SCNSphere(radius: 0.005)

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
    
        let dotNode = SCNNode()
        dotNode.geometry = dotGeometry
        dotNode.position = SCNVector3(location.worldTransform.columns.3.x,
                                   location.worldTransform.columns.3.y,
                                   location.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
    }

}
