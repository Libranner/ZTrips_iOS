//
//  PlacesCollectionViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"
/*
class PlacesCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
  
  var managedObjectContext: NSManagedObjectContext? = nil
  private var observer: NSObjectProtocol?
  private var dataSync: DataSync?
  var itemCount = 0
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let patternImage = UIImage(named: "Pattern") {
      view.backgroundColor = UIColor(patternImage: patternImage)
    }
    collectionView?.backgroundColor = UIColor.white
    collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    
    if let layout = collectionView?.collectionViewLayout as? CustomLayout {
      layout.delegate = self
    }
    
    /*DataDownloader().download { [weak self] (allPlaces) in
     self?.places = allPlaces!
     DispatchQueue.main.async {
     self?.collectionView?.reloadData()
     }
     }*/
    
    sync()
    observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { (notification) in
      self.sync()
    }
  }
  
  private func sync() {
    guard dataSync == nil else {
      return
    }
    
    if let context = self.managedObjectContext {
      dataSync = DataSync(context: context)
      dataSync!.updateFromServer { [weak self] in
        DispatchQueue.main.async {
          try? context.save()
          self?.dataSync = nil
          //self?.collectionView.reloadData()
        }
      }
    }
  }
  
  // MARK: - NSFetchedResultsControllerDelegate
  lazy var fetchedResultsController: NSFetchedResultsController<Place>! = {
    
    let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    
    aFetchedResultsController.delegate = self
    
    do {
      try aFetchedResultsController.performFetch()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    
    return aFetchedResultsController
  }()
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    if collectionView.numberOfItems(inSection: 0) == 0 {
      collectionView.reloadData()
      return
    }
    
    
    collectionView.performBatchUpdates({
      switch type {
      case .insert:
        itemCount += 1
        collectionView.insertItems(at: [newIndexPath!])
      case .delete:
        itemCount -= 1
        collectionView.deleteItems(at: [indexPath!])
      case .update:
        collectionView.reloadItems(at: [indexPath!])
      case .move:
        collectionView.moveItem(at: indexPath!, to: newIndexPath!)
      }
    }, completion: nil)

  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //self.collectionView.reloadData();
    DispatchQueue.main.async {
      self.collectionView!.performBatchUpdates({ () -> Void in
        
      }, completion: { (finished) -> Void in
        
      })
    }
  }
  
  deinit {
    if observer != nil {
      NotificationCenter.default.removeObserver(observer!)
      observer = nil
    }
  }
}

extension PlacesCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionInfo = fetchedResultsController.sections![section]
    let c = sectionInfo.numberOfObjects
    //return c
    return itemCount
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    if let annotateCell = cell as? PlaceCell {
      annotateCell.place = fetchedResultsController.object(at: indexPath)
    }
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: SegueIdentifiers.PLACE_DETAIL, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == SegueIdentifiers.PLACE_DETAIL) {
      let vc = segue.destination as! PlaceDetailViewController
      let place = fetchedResultsController.object(at: (collectionView.indexPathsForSelectedItems?.first!)!)
      vc.place = place
    }
    else if(segue.identifier == SegueIdentifiers.PLACE_FILTERS) {
      guard let navigationController = segue.destination as? UINavigationController,
        let vc = navigationController.topViewController as? FiltersTableViewController else {
          return
      }
      vc.delegate = self
    }
  }
}

extension PlacesCollectionViewController : CustomLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    if indexPath.item % 2 == 0 {
      return 300
    }
    else if indexPath.item % 3 == 0 {
      return 400
    }
    return 500
  }
}

extension PlacesTableViewController: FiltersTableViewControllerDelegate {
  func filtersController(_ controller: FiltersTableViewController, didSelectFilters filters: [String]) {
    //searchedTypes = controller.selectedTypes.sorted()
    dismiss(animated: true)
    //fetchNearbyPlaces(coordinate: mapView.camera.target)
  }
}

*/
