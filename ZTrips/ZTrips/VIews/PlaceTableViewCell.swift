//
//  PlaceTableViewCell.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 20/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainImageView: AsyncImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 3
    containerView.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    mainImageView.image = nil
    titleLabel.text = ""
  }
  
  var place: Place? {
    didSet {
      if let place = place {
        if place.isCustom {
          mainImageView.image = nil
          let fileManager = FileManager.default
          if let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let file = docs.appendingPathComponent(place.mainImageUrl!.absoluteString)
            if let image = UIImage(contentsOfFile: file.path){
               mainImageView.image = image
            }
          }
        }
        else {
          mainImageView.fillWithURL(place.mainImageUrl!, placeholder: nil)
        }
        mainImageView.contentMode = .scaleAspectFill
        titleLabel.text = place.name
      }
    }
  }
  
}
