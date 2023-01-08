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
        
        // 위치를 추적하는데 있어 실제로 무슨일이 일어나고 있는지 좀더 쉽게 확인이 가능하게 점으로 표현을 해준다
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//                // Create a new scene
//                let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//                // Set the scene to the view
//           sceneView.scene = scene
        
        //        makeDice()
    }
    
    @IBAction func rollDiceButtonTapped(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeDiceButtonTapped(_ sender: UIBarButtonItem) {
        // 전체 다이스를 제거하기 위해
        if !diceArray.isEmpty {
            for dice in diceArray {
                // 노드를 제거하는 메서드 removeFromParentNode
                dice.removeFromParentNode()
            }
        }
    }
    
    // 디바이스의 움직임을 관측하여 동작을 실행하는 메서드
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    
    // 터치 대리자 메서드를 통해 ARKit의 객체의 실제 위치를 변경해보기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Set<UITouch>로 구성이 되어있다. 다중 터치를 할경우 컬렉션 Set이 필요하다.
        // 즉, 우리는 단일 터치만 원하므로 첫번재로 접근해서 사용
        if let touch = touches.first {
            // 터치의 위치를 감지하기 위해서 location(in: SKNode)을 사용한다. in: 감지 된 위치
            let touchLocation = touch.location(in: sceneView)
            
            // 화면은 실제로 3D가 아닌 2D이다
            // ARKit의 raycastQuery는 2D 공간에서 터치하는 지점을 3D좌표로 변환시켜준다.
            // from: sceneView의 위치, allowing: 2D공간에서 z축을 추가하여 3D 터치로 만들어줌, alignment: 수평
            guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return }
            let results = sceneView.session.raycast(query)
            
            // hitResult를 프린트해보면 클릭시 좌표마다 worldTransform에서 다른 translation=(x,y,z) translation=(x°,y°,z°)가 나옵니다.
            guard let hitResult = results.first else { return }
            
            // 이제 주사위를 불러 오겠습니다.
            // .scn 파일 직접 불러오기
            let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
            
            // node를 만들어 줘야 한다.
            // withName은 위의 diceCollada로 파일로 접근 후 인스펙터창에서 Identity 이름을 입력 해주면 됩니다.
            // recursively는 재귀적으로 수행하여 여기서 예를들면 Dice의 childNode 모두를 검색 및 사용합니다.
            // (childNode가 없더라도 나중에 추가할 가능성이 있기 때문에 보통은 true로 설정해줍니다)
            guard let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) else {
                fatalError("Failed load SCNScene")
            }
            
            // 위치를 정해줍시다. (터치한 곳의 위치)
            // worldTransform 은 4x4 위치, 회전, 스케일에 대한 행렬입니다.
            // 우리는 클릭 시 주사위를 그 위치에 생성을 시키기 위해 터치 위치(hitResult)를 받아서 만들어보겠다.
            // columns의 4행은 카메라의 따른 원근법이라고 알고 있으면 될꺼같다
            // y축을 이대로 (hitResult.worldTransform.columns.3.y) 설정해주면 객체가 평면 기준으로 반이 짤리는 현상이 발생하게 된다.
            // 즉 y축의 높이를 객체의 크기의 절반만큼 더해줍시다 (diceNode.boundingSphere.radius)
            diceNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                           y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                           z: hitResult.worldTransform.columns.3.z)
            
            // 위치마다 diceNode를 추가 하여 줍니다
            diceArray.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
           
            
            sceneView.autoenablesDefaultLighting = true
        }
    }
    
    func rollAll() {
        
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        // 한 축당 4개의 면이 나오므로 랜덤 숫자를 1~4사이로 설정합니다.
        // 또한 주사위는 90도 마다 숫자가 위로 향하므로 90°를 곱해줍시다.
        let randonX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randonZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        // AR의 애니메이션 효과를 위해여 runAction이라는 메서드를 사용합니다.
        // rotateBy 회전하는 애니메이션을 (x, y, z축을 기준으로 얼마동안(duration) 회전할지 정해줍니다)
        // 랜덤 숫자에 곱하기 5를 해준 이유는 회전이 단조로워서 5바퀴를 더 회전 시키기 위해서 곱해줌
        // y축을 설정안한 이유는 y축기준으로 회전을 한다고 해도 나오는 숫자는 그대로이기 때문에 0으로 설정
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randonX * 5),
                                              y: 0,
                                              z: CGFloat(randonZ * 5),
                                              duration: 1))
    }
    
    func makeDice() {
        // .scn파일이 있는 경우 직접 불러오기
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
        
        // 수평면을 감지하기 위해 configuration에 접근 후 표면을 감지하는 프로퍼티(planeDetection)를 추가합니다
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}

// SceneKit의 델리게이트를 설정해준다.
extension ViewController: ARSCNViewDelegate {
    // renderer : 새로운 anchor의 node가 Scene의 추가 되었을을 알린다.
    // didAdd node : 새로 추가될 노드
    // ARAnchor : ARScene의 객체를 배치하는데 있어 카메라를 기준으로 실제 위치 및 방향 추적함 (일종의 바닥의 깔린 타일과 동일)
    // 이 메서드는 해당 타일을 사용하여 개채를 원하는 곳에 배치합니다.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // ARAnchor는 광범위한 범주이다. (ARPlaneAnchor(평면), ARObjectAnchor(3D 객체), ARImageAnchor(이미지), ARFaceAnchor(얼굴))
        // 우리는 바닥에 주사위를 놓고 싶으니까 이중에서 평면감지를 사용해야 한다.
        
        // ARAnchor를 다운캐스팅하여 ARPlaneAnchor로 변환시킨다.
        // ARPlaneAnchor 속성으로는 planeExtent이 존재한다 (평면에서 감지된 너비와 높이)
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // ScneneKit에 평면을 생성할 수 있도록 SCNPlane을 사용하여 만들어준다
        // 감지된 속성(planeExtent)을 갖고 SCNPlane을 생성시킨다
        let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
        
        // 노트드를 만들어주고 위치와 지오메트리를 설정한다(순서는 위의 달, 큐브, 주사위 만드는 것과 동일하다)
        let planeNode = SCNNode()
        
        // x: center로 맞춤 , y: 수평면을 위하므로 0, z: center로 맞춤
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        // 여기서 한가지 문제점이 있습니다. 헷갈릴 수도 있으니 그림과 함께 보면서 이해해 보세요.
        // 기본적으로 SCNPlane은 수직 평면으로 형성이 됩니다. (x와 y축으로 되어있는 수직평면)
        // 따라서 이 수직면을 x와 z축을 사용하는 평면으로 변환을 해야 합니다. (90°로 눞여야 된다)
        // angle : 기본 단위는 radians입니다, (1 rad = 57.3°, 1π rad = 180° 입니다)
        //         또한 양수일 때 시계방향, 음수일 때 반시계방향임을 고려해야 해야 한다.
        
        // x, y, z의 축으로 회전 시킨다. (1이면 사용, 0이면 사용하지 않음)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2 , 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        
        // 팁으로 png 파일은 투명도가 제공이 됩니다. grid의 빈곳은 배경이 보이죠.
        // grid.png 불러온다.
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        // 뼈대 설정
        planeNode.geometry = plane
        
        // addChildNode를 추가 해준다.
        node.addChildNode(planeNode)
    }
}

