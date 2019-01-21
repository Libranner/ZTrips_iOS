//
//  DataSync.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 19/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataSync{
  private var context: NSManagedObjectContext
  
  //TODO: Check if this can be refactored. Specially to start the background task with the http request
  //TODO: Use enums or constants for the Entity Names
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func updateFromServer(completion:@escaping ()->Void)  {
    DataDownloader.init().download(completion: { (places) in
      let bkTask = UIApplication.shared.beginBackgroundTask {
        debugPrint("Download stopped")
      }
      
      guard places != nil else {
        DispatchQueue.main.async {
          UIApplication.shared.endBackgroundTask(bkTask)
        }
        completion()
        return
      }
      
      let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      context.parent = self.context
      
      for place in places! {
        let req = Place.fetchRequest() as NSFetchRequest<Place>
        req.predicate = NSPredicate(format: "name == %@", place.name)
        
        if let result = try? context.fetch(req),
          result.count > 0 {
            let currentPlace = result.first!
            currentPlace.name = place.name
            currentPlace.mainImageUrl = place.mainImageUrl
            currentPlace.schedule = place.schedule
            currentPlace.type = place.type
            currentPlace.website = place.website
            currentPlace.summary = place.summary
        } else {
          if let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place {
            newPlace.name = place.name
            newPlace.mainImageUrl = place.mainImageUrl
            newPlace.schedule = place.schedule
            newPlace.type = place.type
            newPlace.website = place.website
            newPlace.summary = place.summary
            
            if let newCoordinate = NSEntityDescription.insertNewObject(forEntityName: "Coordinate", into: context) as? Coordinate {
              newCoordinate.latitude = place.coordinate.latitude
              newCoordinate.longitude = place.coordinate.longitude
              newCoordinate.radio = place.coordinate.radio
              newPlace.coordinate = newCoordinate
            }
          }
        }
      }
      
      try? context.save()
      
      completion()
      
      DispatchQueue.main.async {
        UIApplication.shared.endBackgroundTask(bkTask)
      }
    })
  }

}
