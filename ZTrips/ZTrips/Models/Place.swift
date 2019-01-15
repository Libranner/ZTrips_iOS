//
//  Place.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 02/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct Place: Codable {
  let name: String
  let type: String
  let schedule: String
  let coordinate: Coordinate
  let mainImageUrl: URL
  let website: String
  let summary: String
  
  // Enum para hacer el mapeo entre los nombres de las propiedades en el Json y los del struct
  enum CodingKeys: String, CodingKey {
    case name
    case type
    case schedule
    case coordinate
    case mainImageUrl = "image"
    case website
    case summary = "description"
  }
}
