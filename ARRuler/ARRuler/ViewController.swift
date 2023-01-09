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
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // 점으로 무슨일 일어는지 표현
        //        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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
        resetDot()
        
        guard let touch = touches.first else { return }
        
        // 터치되는 위치 얻기
        let touchLocation = touch.location(in: sceneView)
        
        // 2D공간(화면)을 3D로 좌표를 계산하여 변환시켜 준다.
        guard let query = sceneView.raycastQuery(from: touchLocation,
                                                 allowing: .existingPlaneGeometry,
                                                 alignment: .any) else { return }
        
        // 터치시 3D공간의 위치 정보 결과들
        let hitResults = sceneView.session.raycast(query)
        
        // 터치시 3D공간의 위치결과
        guard let hitResult = hitResults.first else { return }
        
        addDot(at: hitResult)
    }
    
    func addDot(at location: ARRaycastResult) {
        
        let dotGeometry = SCNSphere(radius: 0.002)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode()
        dotNode.geometry = dotGeometry
        dotNode.position = SCNVector3(location.worldTransform.columns.3.x,
                                      location.worldTransform.columns.3.y,
                                      location.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        // 나중에 초기화 시킬 때 사용하려고 전역변수에 담았습니다.
        dotNodes.append(dotNode)
        
        // 점을 두번 찍으면 계산하게 만들었습니다.
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        // 그림 참고 월드 좌표계의 2점 사이의 거리 구하기
        // sqrt 제곱근(루트, √) 만드는 함수 , pow 제곱하기
        let distance = sqrtf(powf(end.position.x - start.position.x, 2) +    // 변 PQ
                             powf(end.position.y - start.position.y, 2) +    // 변 BQ
                             powf(end.position.z - start.position.z, 2))     // 변 AP
        
        // cm로 변형
        let distanceUnitCm = String(format: "%.2f", distance * 100)
        
        updateText(text: distanceUnitCm + "Cm", atPosition: start.position)
    }
    
    func updateText(text: String, atPosition position: SCNVector3) {
        // 업데이트 될때 마다 텍스트 지우기
        textNode.removeFromParentNode()
        
        // 입체감 있는 텍스트를 생성
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x + 0.05, position.y  , position.z - 0.25)
        
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func resetDot() {
        if dotNodes.count >= 2 {
            dotNodes.forEach { $0.removeFromParentNode() }
            dotNodes = [SCNNode]()
        }
    }
    
}
