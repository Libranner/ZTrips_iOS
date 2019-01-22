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
UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
  
  var imagePickerController: UIImagePickerController!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var placeDescriptionTextView: UITextView!
  @IBOutlet weak var placeNameTextField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var newPlaceView: UIView!
  @IBOutlet weak var typeTextField: UITextField!
  
    var typePickerView: UIPickerView!
  private let types = Constants.FILTERS
  
  @IBOutlet weak var takePhotoButton: UIButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    typePickerView = UIPickerView()
    typePickerView.delegate = self
    typeTextField.inputView = self.typePickerView
    typeTextField.delegate = self
    
    placeNameTextField.layer.borderColor = UIColor.orange.cgColor
    placeNameTextField.layer.borderWidth = 1.0
    placeNameTextField.layer.cornerRadius = 6
    placeNameTextField.delegate = self
    
    typeTextField.layer.borderColor = UIColor.orange.cgColor
    typeTextField.layer.borderWidth = 1.0
    typeTextField.layer.cornerRadius = 6
    
    placeDescriptionTextView.layer.borderWidth = 1
    placeDescriptionTextView.layer.borderColor = UIColor.orange.cgColor
    placeDescriptionTextView.layer.cornerRadius = 6
    placeDescriptionTextView.delegate = self
  }
    
    //MARK: Animations
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newPlaceAnimate()
    }
    
    func newPlaceAnimate() {
        scrollView.transform = CGAffineTransform.init(translationX: 0, y: +view.bounds.size.height )
        scrollView.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.alpha = 1
        }, completion: nil)
    }
    
  //MARK: - TextView Delegate
  func textViewDidBeginEditing(_ textView: UITextView) {
    scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y), animated: true);
  }
  
  //MARK: - TextField Delegate
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y), animated: true);
    return true
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
    scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
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
  func savePhoto() -> String? {
    let photo = imageView.image!

    let fm = FileManager.default
    if let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
      let fileName = "\(UUID().uuidString).png"
      let filePath = docs.appendingPathComponent(fileName)
      if let photoData = photo.jpegData(compressionQuality: 0.5) {
        try! photoData.write(to: filePath)
      }
      return fileName
    }
  
    return nil
  }
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {    
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
    guard imageView.image != nil else {
      return false
    }
    
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
    guard path != nil else {
      return
    }
    
    if let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place {
      newPlace.name = placeNameTextField.text
      newPlace.mainImageUrl = URL(string: path!)
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
    do {
      try context.save()
      let alert = UIAlertController(title: "Place added", message: "Place has been added", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default)
      alert.addAction(okAction)
      let goToAction = UIAlertAction(title: "Go to Places List", style: .cancel) { _ in
        self.tabBarController?.selectedIndex = 0
      }
      alert.addAction(goToAction)
      present(alert, animated: true, completion: { [weak self] in
        self?.hideKeyboard()
        self?.cleanup()
      })
    }
    catch {
      let alert = UIAlertController(title: "Error", message: "An error has ocurred trying to create this place", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
  }
  
  func cleanup() {
    typeTextField.text = ""
    placeDescriptionTextView.text = ""
    placeNameTextField.text = ""
    imageView.image = nil
    takePhotoButton.isHidden = false
  }
}


