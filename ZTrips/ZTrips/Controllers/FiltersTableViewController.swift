import UIKit

protocol FiltersTableViewControllerDelegate: class {
  func filtersController(_ controller: FiltersTableViewController, didSelectFilters filters: [String])
}

class FiltersTableViewController: UITableViewController {
  
  private let filters = ["Comida & Bebida", "Museo & Monumentos",  "Entretenimiento"]
  
  weak var delegate: FiltersTableViewControllerDelegate?
  var selectedFilters: [String] = []
  
  
  // MARK: - Actions
  @IBAction func donePressed(_ sender: AnyObject) {
    delegate?.filtersController(self, didSelectFilters: selectedFilters)
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filters.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
    let filter = filters[indexPath.row]
    cell.textLabel?.text = filter
    cell.accessoryType = selectedFilters.contains(filter) ? .checkmark : .none
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let filter = filters[indexPath.row]
    if selectedFilters.contains(filter) {
      selectedFilters = selectedFilters.filter({$0 != filter})
    } else {
      selectedFilters.append(filter)
    }
    
    tableView.reloadData()
  }
}

