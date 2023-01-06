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
        
        //        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //
        //        // Set the scene to the view
        //        sceneView.scene = scene
        
        makeDice()
    }
    
    func makeDice() {
        // .dae파일이 있는 경우 직접 불러오기
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        // node를 만들어 줘야 한다.
        // withName은 위의 diceCollada로 파일로 접근 후 인스펙터창에서 Identity 이름을 입력 해주면 됩니다.
        // recursively는 재귀적으로 수행하여 여기서 예를들면 Dice의 childNode 모두를 검색 및 사용합니다.
        // (childNode가 없더라도 나중에 추가할 가능성이 있기 때문에 보통은 true로 설정해줍니다)
        guard let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) else {
            fatalError("Failed load SCNScene")
        }
        
        // node를 추가해줬으면 역시나 node의 위치를 정해줘야 합니다.
        diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
        
        sceneView.scene.rootNode.addChildNode(diceNode)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    func makeCube() {
        // 앞의 SCN은 Scene의 줄임말 (SceneKit 프레임워크)
        // 정육면체를 만든다 (SCNBox 파라미터의 단위는 미터(m)이다, chamferRadius: 모서리를 둥글게)
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        // 재료 설정을 위해 Scene의 material 생성
        let material = SCNMaterial()
        
        // 색상 설정
        material.diffuse.contents = UIColor.red
        
        // 위의 만든 큐브에 재질을 만든 재질로 변경 (배열로 감싼다)
        cube.materials = [material]
        
        // 큐브를 만들고 스타일까지 만들어 줬습니다.
        // 다음으로 Node를 만들어줘야 합니다.
        // SCNNode는 기본적으로 3D 공간의 위치를 나타낸다. 위치를 지정하고 개체를 생성해야한다.
        // SCNNode안에는 기본적으로 아무것도 보이지 않습니다.
        // 눈에 보이는 콘텐츠를 만들려면 조명, 카메라 또는 지오메트리(뼈 대)와 같은 다른 구성 요소를 노드에 추가해야 합니다.
        let node = SCNNode()
        
        // position의 타입은 SCNVector3입니다. 3차원 벡터(X, Y, Z)를 가르킨다.
        // 여기서 Z축만 왜 마이너스(-)를 사용하는가? 양수이면 Z축의 방향은 나에게 오는 방향이다.
        // 나를 기준으로 멀리 떨어뜨리려고 마이너스를 사용함
        node.position = SCNVector3(x: 0, y: 0.05, z: -0.5)
        
        // geometry: node와 연결된 형상을 가르킨다 (뼈대)
        node.geometry = cube
        
        // rootNode: 기존에 있던 노드에서 addChildNode로 새로운 노드를 추가 시킨다.
        // 예를들면 프로젝트를 처음 만들때 생성이 되있던 비행기 shipMesh 자체가 rootNode이고
        // shipMesh 내부에 있는 emitter가 addChildNode 이다
        sceneView.scene.rootNode.addChildNode(node)
        
        // 위의 과정까지 마치면 뭔가 입체감이 없는 주사위가 만들어졌을 것이다.
        // 그 이유는 빛과 그림자 설정을 안해줘서 그렇다 autoenablesDefaultLighting는 자동으로 조명값을 만들어 준다.
        sceneView.autoenablesDefaultLighting = true
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
