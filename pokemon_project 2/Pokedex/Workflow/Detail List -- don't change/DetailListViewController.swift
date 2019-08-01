import UIKit

final class DetailListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var model: DetailListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailListViewController = segue.destination as? DetailListViewController, let details = sender as? [Detail] else { return }
        
        let model = DetailListModel(details: details)
        detailListViewController.setup(model: model)
    }
}

extension DetailListViewController {
    func setup(model: DetailListModel) {
        self.model = model
    }
}

extension DetailListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = model.details[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell")!
        
        cell.textLabel?.text = detail.titleText
        cell.detailTextLabel?.text = detail.detailText
        cell.accessoryType = detail.isSelectable ? .disclosureIndicator : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.rowHeight
    }
}

extension DetailListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = model.details[indexPath.row]
        
        guard detail.isSelectable else { return }

        performSegue(withIdentifier: "ShowMoreDetails", sender: detail.additionalDetails)
    }
}
