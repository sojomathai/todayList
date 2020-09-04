//
//  FInderViewController.swift
//  Today List
//
//  Created by sojo mathai on 2020-08-01.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import UIKit
import CoreML
import Vision

class FInderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageViewForCamera: UIImageView!
    
    let imagePickerContro = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerContro.delegate = self
        imagePickerContro.sourceType = .camera
        imagePickerContro.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageCaptured = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
        imageViewForCamera.image = imageCaptured
            
            guard let ciImage1 = CIImage(image: imageCaptured) else{
                fatalError("Error in converting CIImage ")
            }
            
            imageDetection(image1: ciImage1)
            
        }
        imagePickerContro.dismiss(animated: true, completion: nil)
        
    }
    
    func imageDetection(image1: CIImage){
        
        guard let imageModel = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Image Converions to Vn Core failed ")
        }
        
        let imageRequest = VNCoreMLRequest(model: imageModel) { (imageRequest, error) in
            
            guard let results = imageRequest.results as? [VNClassificationObservation] else {
                fatalError("Image Request Failked ")
            }
           
            if let firtResultsIde = results.first{
                
                let item = firtResultsIde.identifier
                
                self.navigationItem.title = item
            }else{
                self.navigationItem.title = "Sorry Cant FInd"
            }
            
        }
        
        let handlerRequest = VNImageRequestHandler(ciImage: image1)
        do{
            try handlerRequest.perform([imageRequest])
        
        }catch{
            print("eroro in halding \(error)")
        }
        
    }
        
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        present(imagePickerContro, animated: true, completion: nil)
        
       
    }
    
    
}
