//
//  ViewController.swift
//  SeeFood
//
//  Created by marco alonso on 17/04/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var opc1: UILabel!
    @IBOutlet weak var opc2: UILabel!
    @IBOutlet weak var opc3: UILabel!
    @IBOutlet weak var opc4: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let imagePickerLibrary = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: "Bienvenido", message: "Capturta una imagen con tu cámara o selecciona una de tu galeria de fotos", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        
        self.present(alert,animated: true)
        

        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        imagePickerLibrary.delegate = self
        imagePickerLibrary.sourceType = .photoLibrary
        imagePickerLibrary.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Error al convertir UUimage a CIImage")
            }
            
            detect(image: ciimage)
            
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        imagePickerLibrary.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image: CIImage) {
           guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
               fatalError("No se pudo crear el modelo CoreML")
           }
           //comprobar que existe nuestro modelo
           let request = VNCoreMLRequest(model: model) { (request, error) in
               //procesar los resultados de la solicitud
               guard let results = request.results as? [VNClassificationObservation] else {
                   fatalError("Error al procesar la solicitud del modelo")
               }
            
            self.navigationItem.title = "Posibles Objetos"
            
            self.opc1.text = results[0].identifier
            self.opc2.text = results[1].identifier
            self.opc3.text = results[2].identifier
            self.opc4.text = results[3].identifier
            
           }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("error : \(error.localizedDescription)")
        }
                   
       }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        present(imagePickerLibrary, animated: true, completion: nil)
    }
    
   
    
}

