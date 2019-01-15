//
//  DataDownloader.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 02/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

struct DataDownloader {
  
  // Contruimos el URL del archivo Json
  private let placesUrl = ApiUrlCreator.createUrl(path: "all_places.json")
  
  func download(completion: @escaping ([Place]?) -> Void) {
    let session = URLSession.shared
    
    /// Aseguramos que esta tarea sea finalizada si el App está en background
    let backgrounTask = UIApplication.shared.beginBackgroundTask {
      debugPrint("Download stopped")
    }

    /// Creamos el URL Request para obtener la data.
    /// Nos aseguramos que ignore la caché, para obtener siempre la última versión
    let request = URLRequest(url: URL(string: placesUrl)!,  cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 0.0)
    
    // Construimos la tarea usando el URLRequest creado anteriormente
    let task = session.dataTask(with:request) {
      data, response, error in
      
      /// Verificamos si ha ocuriddo un error o la data es nil. Si esto pasa paramos nil a completion closure e indicamos que la tarea ha terminado
      guard let unWrappedData = data, error == nil else {
        completion(nil)
        UIApplication.shared.endBackgroundTask(backgrounTask)
        return
      }

      /// Decodificamos el Json retornado y lo convertimos en un arreglo de structs `place`
      let places = try? JSONDecoder().decode([Place].self, from: unWrappedData)
      
      /// Pasamos el arreglo al completion closure
      completion(places)
      
      /// Indicamos que la tarea ha terminado
      UIApplication.shared.endBackgroundTask(backgrounTask)
    }
    
    /// Ejecutamos la tarea
    task.resume()
  }
  
}
