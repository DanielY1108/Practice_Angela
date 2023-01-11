//
//  ViewController.swift
//  MagicPaper
//
//  Created by JINSEOK on 2023/01/11.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        // Assets 폴더의 AR 이미지를 불러오기
        if let trackToImage = ARReferenceImage.referenceImages(inGroupNamed: "NewsPapaerImages", bundle: Bundle.main) {
            // 인식할 이미지
            configuration.trackingImages = trackToImage
            // 인식한 이미지의 개수
            configuration.maximumNumberOfTrackedImages = 1
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        
        let videoScene = addVideo()
        let planeNode = addPlane(on: imageAnchor, addVideo: videoScene)
        
        node.addChildNode(planeNode)
        
        return node
    }
    
    func addVideo() -> SKScene {
        // 동영상 재생을 위해 SpriteKit의 SKVideoNode를 생성해 줍니다.
        // 저장해 논 비디오파일을 읽어줍시다.
        let videoNode = SKVideoNode(fileNamed: "Harrypotter.mp4")
        
        // 동영상 재생
        videoNode.play()
        
        // SpriteKit의 비디오 재생 요소를 sceneKit에 추가를 해줘야 합니다.
        // SKScene을 추가 해줍시다. SKScene은 SpriteKit의 요소입니다.
        // 장면의 크기는 동영상의 크기로 맞춰 줍시다 (제가 저장한 동영상은 720p 이므로 720 x 1080 설정)
        let videoScene = SKScene(size: CGSize(width: 1080, height: 720))
        
        // 위치를 조정해줍시다.
        // videoNode의 위치를 videoScene의 중간에 위치하게 만들어 줍시다.
        videoNode.position = CGPoint(x: videoScene.size.width / 2,
                                     y: videoScene.size.height / 2)

        // 회전을 시키기 위해서는 두가지 옵션이 있다.
        // 1. zRotation을 통해 180° 돌려주기
        // 2. yScale는 기본값이 +1 입니다 -1로 설정해주면 반전 됨
        
        // 필자는 스케일도 조절하고 싶어 2번 사용
        // videoNode.zRotation = CGFloat(Float.pi)
        videoNode.yScale = -1.35
        
        // 비디오를 추가해 줬으니 이제 2D로 표시할 준비가 됐습니다.
        // 현재 까지는 3D 환경에서 작업을 하는 중이기 때문에 2D인 SKScene는 나타나지 않습니다.
        // 밑에 만들 평면의 material의 diffuse.contents를 SKScene로 바꿔줘야 합니다.
        videoScene.addChild(videoNode)
        
        return videoScene
    }
    
    func addPlane(on imageAnchor: ARImageAnchor, addVideo: SKScene) -> SCNNode {
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = addVideo
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -(Float.pi/2)
        
        return planeNode
    }
}


func addPlane(on imageAnchor: ARImageAnchor, addVideo: SKScene) -> SCNNode {
    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                         height: imageAnchor.referenceImage.physicalSize.height)
    
    plane.firstMaterial?.diffuse.contents = addVideo
    
    let planeNode = SCNNode(geometry: plane)
    planeNode.eulerAngles.x = -(Float.pi/2)
    
    return planeNode
}
