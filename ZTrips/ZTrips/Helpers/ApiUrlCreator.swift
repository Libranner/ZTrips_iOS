//
//  ApiConstants.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 02/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

// Clase para manejar las constantes relacionadas al API, utilzadas en toda el app
class ApiUrlCreator {
  // Constante con el base URL del API
  private static let BASE_URL = "https://firebasestorage.googleapis.com/v0/b/test-5596f.appspot.com/o/"
  private static let QUERY_STRING = "?alt=media&token=eab775fa-5b12-4323-b898-099a4c7a5047"
  
  static func createUrl(path: String) -> String {
    return "\(BASE_URL)\(path)\(QUERY_STRING)".replacingOccurrences(of: " ", with: "%20")
  }
}
