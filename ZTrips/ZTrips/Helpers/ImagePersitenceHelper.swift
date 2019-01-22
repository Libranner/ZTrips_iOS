//
//  ImagePersitenceHelper.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 22/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

class ImagePersistenceHelper {
  let fileManager = FileManager.default
  func loadImage(destinationImageView: AsyncImageView, place: Place) {
    if place.isCustom {
      
      if let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let file = docs.appendingPathComponent(place.mainImageUrl!.absoluteString)
        if let image = UIImage(contentsOfFile: file.path){
          destinationImageView.image = image
        }
      }
    }
    else {
      destinationImageView.fillWithURL(place.mainImageUrl!, placeholder: nil)
    }
  }
  
  func saveImage(image: UIImage) -> String? {
    if let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
      let fileName = "\(UUID().uuidString).png"
      let filePath = docs.appendingPathComponent(fileName)
      if let photoData = image.jpegData(compressionQuality: 0.5) {
        try! photoData.write(to: filePath)
      }
      return fileName
    }
    
    return nil
  }
}
