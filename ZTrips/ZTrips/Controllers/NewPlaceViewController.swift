//
//  NewPlaceViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class NewPlaceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
  
    @IBOutlet var newPlaceView: UIView!
    
  var imagePickerController: UIImagePickerController!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageName: UITextField!
  
  @IBOutlet weak var takePhotoButton: UIButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    self.view.addGestureRecognizer(tapGesture)
  }
  
    //MARK: Animations
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newPlaceAnimate()
    }
    
    func newPlaceAnimate() {
        newPlaceView.transform = CGAffineTransform.init(translationX: 0, y: +view.bounds.size.height )
        newPlaceView.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
            self.newPlaceView.transform = CGAffineTransform.identity
            self.newPlaceView.alpha = 1
        }, completion: nil)
        
    }
  

    //MARK: Save a New Place...
    
  @objc func hideKeyboard() {
    self.view.endEditing(true)
  }
  
    //take the photo
  @IBAction func tappedTakePhotoButton(_ sender: Any) {
    imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .camera
    present(imagePickerController, animated: true, completion: nil)
  }
    
  //place the photo on the image view
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
      imagePickerController.dismiss(animated: true, completion: nil)
      imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      takePhotoButton.isHidden = true
  }
  
  //save the photo
  func savePhoto(photoName: String) {
    let fileManager = FileManager.default
    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(photoName)
    let photo = imageView.image!
    let photoData = photo.pngData()
    fileManager.createFile(atPath: imagePath, contents: photoData, attributes: nil)
  }

    //save new place
  @IBAction func saveButton(_ sender: UIButton){
      sender.pulseButton()
      savePhoto(photoName: imageName.text!)
      print(imageName.text as Any)
  }

}


