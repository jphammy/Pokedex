import UIKit

final class SpeciesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var model: SpeciesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailListViewController = segue.destination as? DetailListViewController else { return }
        
        let model = DetailListModel(details: sender as? [Detail] ?? [])
        detailListViewController.setup(model: model)
    }
}

extension SpeciesViewController {
    func setup(model: SpeciesViewModel) {
        self.model = model
    }
}

extension SpeciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let property = model.properties[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeciesPropertyCell")!
        cell.textLabel?.text = property.title
        cell.detailTextLabel?.text = property.value
        cell.accessoryType = model.hasDetails(forDataType: property.detailType) ? .disclosureIndicator : .none
        
        return cell
    }
}

extension SpeciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailType = model.detailType(at: indexPath.row), model.hasDetails(forDataType: detailType) else { return }
        
        performSegue(withIdentifier: "ShowSpeciesDetails", sender: model.details(forDataType: detailType))
    }
}
