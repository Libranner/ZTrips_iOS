//
//  PlacesTableViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 20/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreData

class PlacesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  private let reuseIdentifier = "Cell"
  var managedObjectContext: NSManagedObjectContext? = nil
  private var observer: NSObjectProtocol?
  private var dataSync: DataSync?
  private var selectedFilters = Constants.FILTERS
  private var notificationSetted = false
  
  var fetchedResultsController: NSFetchedResultsController<Place>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let patternImage = UIImage(named: "Pattern") {
      view.backgroundColor = UIColor(patternImage: patternImage)
    }
    tableView?.backgroundColor = UIColor.white
    tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    setupFetchResultController()
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
          self?.reloadData()
          if !(self?.notificationSetted)! {
            PlacesManager.shared.setupInPlaceNotifications(context: context)
            self?.notificationSetted = true
          }
        }
      }
    }
  }
  
  @IBAction func showMapTapped(_ sender: Any) {
    self.performSegue(withIdentifier: SegueIdentifiers.SHOW_MAP, sender: self)
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlaceTableViewCell
    
    let place = fetchedResultsController.object(at: indexPath)
    configureCell(cell, withPlace: place)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let context = fetchedResultsController.managedObjectContext
      context.delete(fetchedResultsController.object(at: indexPath))
      
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: SegueIdentifiers.PLACE_DETAIL, sender: self)
  }
  
  func configureCell(_ cell: PlaceTableViewCell, withPlace place: Place) {
    cell.place = place
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == SegueIdentifiers.PLACE_DETAIL) {
      let vc = segue.destination as! PlaceDetailViewController
      let place = fetchedResultsController.object(at: (tableView.indexPathForSelectedRow!))
      vc.place = place
    }
    else if(segue.identifier == SegueIdentifiers.PLACE_FILTERS) {
      guard let navigationController = segue.destination as? UINavigationController,
        let vc = navigationController.topViewController as? FiltersTableViewController else {
          return
      }
      vc.selectedFilters = selectedFilters
      vc.delegate = self
    }
    else if(segue.identifier == SegueIdentifiers.SHOW_MAP) {
      let vc = segue.destination as! MapViewController
      vc.places = fetchedResultsController.fetchedObjects
    }
  }
  
  // MARK: - Fetched results controller
  func setupFetchResultController() {
    let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:
      self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = self
  }
  
  func reloadData() {
    fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "type IN %@", selectedFilters)
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    self.tableView.reloadData()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    default:
      return
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      configureCell(tableView.cellForRow(at: indexPath!)! as! PlaceTableViewCell,
                    withPlace: anObject as! Place)
    case .move:
      configureCell(tableView.cellForRow(at: indexPath!)! as! PlaceTableViewCell,
                    withPlace: anObject as! Place)
      tableView.moveRow(at: indexPath!, to: newIndexPath!)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
 
  @IBAction func showFiltersTapped(_ sender: Any) {
    self.performSegue(withIdentifier: SegueIdentifiers.PLACE_FILTERS, sender: self)
  }
}

extension PlacesTableViewController: FiltersTableViewControllerDelegate {
  func filtersController(_ controller: FiltersTableViewController, didSelectFilters filters: [String]) {
    selectedFilters = filters
    if selectedFilters.count > 0 {
      reloadData()
    }
 
    dismiss(animated: true)
  }
}
