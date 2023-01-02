//
//  ViewController.swift
//  SeeFood
//
//  Created by JINSEOK on 2023/01/02.
//

import UIKit
import CoreML
import Vision  // CoreML과 작업을 할 때 이미지를 보다 쉽게 처리할 수 있게 도와주는 프레임워크

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImagePicker()
    }

    func setupImagePicker() {
        imagePicker.delegate = self
        // 기본값은 카메라 라이브러리, 이미지를 찍을 수 있게 설정
        imagePicker.sourceType = .camera
        // 선택한 이미지나 동영상 편집 여부를 설정(Bool)
        imagePicker.allowsEditing = false
    }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        // UIImagePickerController도 ViewController 이므로 present로 불러와야 한다.
        present(imagePicker, animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: UIImagePickerControllerDelegate {
    // 이미지 고르는 작업이 끝난 뒤 할 일 정의
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 키 값으로 무보정 원본을 이미지를 받아온다.
        guard let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = userPickedImage
        
        // CoreML로 얻을 수 있는 이미지 형태로 변형(CIImage)
        guard let coreImage = CIImage(image: userPickedImage) else { return }
        
        detect(image: coreImage)
        
        // dismiss
        imagePicker.dismiss(animated: true)
    }
    
    // CoreML의 CIImage를 처리하고 해석하기 위한 메서드 생성
    func detect(image: CIImage) {
            // Vision프레임워크의 VNCoreMLModel 컨터이너를 사용하여 CoreML의 모델인 Inceptionv3를 객체를 생성 후 model에 접근한다.
            // 이것은 모델의 이미지를 분류하기 위해 사용 됨
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: .init()).model) else {
            fatalError("Loading CoreML Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { request, error in
            guard error == nil else { return }
            // VNClassificationObservation = 이미지 분석을 수행한 결과입니다.
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            guard let firstResult = result.first else { return }
            if firstResult.identifier.contains("hotdog") {
                self.navigationItem.title = "Hotdog!"
            } else {
                self.navigationItem.title = "Not Hotdog!"
            }
            // 첫번째 배열의 매치 확률
            print(firstResult.confidence * 100)

        }
        // 함수의 파라미터를 받아서 perform을 요청하여 분석한다.
        let handeler = VNImageRequestHandler(ciImage: image)
    
        do {
            try handeler.perform([request])
        } catch {
            print("Handler Error: \(error)")
        }
    }
}


