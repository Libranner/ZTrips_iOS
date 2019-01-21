//
//  NewPlaceViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreData

class NewPlaceViewController: UIViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
  var imagePickerController: UIImagePickerController!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var placeDescriptionTextView: UITextView!
  @IBOutlet weak var placeNameTextField: UITextField!
 
  @IBOutlet weak var typeTextField: UITextField!
   var typePickerView: UIPickerView!
  private let types = ["Comida & Bebida", "Museo & Monumentos",  "Entretenimiento"]
  
  @IBOutlet weak var takePhotoButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    typePickerView = UIPickerView()
    typePickerView.delegate = self
    typeTextField.inputView = self.typePickerView
    
    placeNameTextField.layer.borderColor = UIColor.orange.cgColor
    placeNameTextField.layer.borderWidth = 1.0
    placeNameTextField.layer.cornerRadius = 6
    
    typeTextField.layer.borderColor = UIColor.orange.cgColor
    typeTextField.layer.borderWidth = 1.0
    typeTextField.layer.cornerRadius = 6
    
    placeDescriptionTextView.layer.borderWidth = 1
    placeDescriptionTextView.layer.borderColor = UIColor.orange.cgColor
    placeDescriptionTextView.layer.cornerRadius = 6
  }
  
  //MARK: - Picker Delegate
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return types[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    typeTextField.text = types[row]
  }
  
  //MARK: - Picker Datasource
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return types.count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  @objc func hideKeyboard() {
    self.view.endEditing(true)
  }
  //Take photo
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
  func savePhoto() -> String {
    let photo = imageView.image!
    let fileManager = FileManager.default
    let fileId = UUID().uuidString
    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
      .appendingPathComponent(fileId)
    let photoData = photo.pngData()
    fileManager.createFile(atPath: imagePath, contents: photoData, attributes: nil)
    
    return imagePath
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    if isValid() {
      let appDelegate = UIApplication.shared.delegate as? AppDelegate
      if let context = appDelegate?.persistentContainer.viewContext {
        save(context: context)
      }
    }
    else {
      let alert = UIAlertController(title: "Form not completed", message: "Make sure to add a photo and fill all the fields", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
  }
  
  private func isValid() -> Bool{
    guard placeNameTextField.text != nil && !placeDescriptionTextView.text!.isEmpty else {
      return false
    }
    
    guard typeTextField.text != nil && !typeTextField.text!.isEmpty else {
      return false
    }

    guard placeDescriptionTextView.text != nil && !placeDescriptionTextView.text!.isEmpty else {
      return false
    }
    
    return true
  }
  
  func save(context: NSManagedObjectContext) {
    let path = savePhoto()
    if let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place {
      newPlace.name = placeNameTextField.text
      newPlace.mainImageUrl = URL(string: path)
      newPlace.type = types[typePickerView.selectedRow(inComponent: 0)]
      newPlace.summary = placeDescriptionTextView.text
      newPlace.isCustom = true
      
      if let coordinate = LocationService.shared.lastLocation?.coordinate,
        let newCoordinate = NSEntityDescription.insertNewObject(forEntityName: "Coordinate", into: context) as? Coordinate {
        newCoordinate.latitude = coordinate.latitude
        newCoordinate.longitude = coordinate.longitude
        newPlace.coordinate = newCoordinate
      }
    }
    try! context.save()
  }
}


