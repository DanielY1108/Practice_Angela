//
//  ViewController.swift
//  ARDicee
//
//  Created by JINSEOK on 2023/01/05.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        makeSphere()
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    func makeSphere() {
        // 구 모양을 생성한다.
        let sphere = SCNSphere(radius: 0.2)
        
        let material = SCNMaterial()
        
        // 추가한 texture 파일을 UIImage로 불러오기만 하면된다.
        // art.scnassets 폴더 안에 있으므로 경로를 추가하여 넣어준다.
        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpeg")
        
        sphere.materials = [material]
        
        let node = SCNNode()
        
        node.position = SCNVector3(x: 0, y: 0.05, z: -1)
        
        node.geometry = sphere
       
        // 배경 추가하기
        sceneView.scene.background.contents = UIImage(named: "art.scnassets/space.jpeg")
        
        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // 나의 기기가 지원하는지 알수 있습니다. (요즘은 대부분 iPhoneSE 이상을 사용하므로 딱히 분기처리를 하여 사용할 필요는 없을 듯 싶다)
        print("Orientation Tracking is supported = \(ARConfiguration.isSupported)")
        print("World Tracking is supported = \(ARWorldTrackingConfiguration.isSupported)")

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
