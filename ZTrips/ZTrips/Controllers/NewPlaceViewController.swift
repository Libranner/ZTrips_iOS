//
//  NewPlaceViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class NewPlaceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePickerController: UIImagePickerController!
   
    @IBOutlet weak var imageView: UIImageView!
    var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Take photo, please note this is not connected
    @IBAction func photoButton (_sender: Any){
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //place the photo on the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
    }
    
    @IBOutlet weak var imageName: UITextField!
    
    //save the photo
    func savePhoto(photoName: String) {
    
    let fileManager = FileManager.default
    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(photoName)
    let photo = imageView.image!
    let photoData = photo.pngData()
    fileManager.createFile(atPath: imagePath, contents: photoData, attributes: nil)
        
    }

    @IBAction func saveButton(_sender: Any){
        savePhoto(photoName: "photo1.png")
    }
    
    //close the View Controller and go Back to Main
    @IBAction func Close(){
        dismiss(animated: true, completion: nil)
    }
}


