import UIKit

protocol SelectionListViewControllerDelegate: class {
    func update(selections: [Selection], forType selectionType: Selection.DataType)
}

final class SelectionListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var model: SelectionListModel!
    private weak var delegate: SelectionListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.selectionType.rawValue
    }
}

extension SelectionListViewController {
    func setup(model: SelectionListModel, delegate: SelectionListViewControllerDelegate) {
        self.model = model
        self.delegate = delegate
    }
}

extension SelectionListViewController {
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let selections = model.selections.map { $0.option }
        delegate?.update(selections: selections, forType: model.selectionType)
    }
}

extension SelectionListViewController {
    private func presentRemoveSelectionAlert(toMakeRoomFor index: Int) {
        let alert = UIAlertController(title: nil, message: "Maximum number of \(model.selectionType.rawValue) reached. Select an option to remove or cancel.", preferredStyle: .actionSheet)
        
        model.selections.forEach { selection in
            let action = UIAlertAction(title: selection.option.title, style: .default) { [weak self] _ in
                self?.model.toggleSelection(at: selection.index)
                self?.model.toggleSelection(at: index)
                self?.tableView.reloadData()
            }
            
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension SelectionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selection = model.options[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell")!
        cell.textLabel?.text = selection.title
        cell.accessoryType = model.isSelected(at: indexPath.row) ? .checkmark : .none
        
        return cell
    }
}

extension SelectionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if model.hasReachedMaximumSelectionCount {
            if model.isSelected(at: indexPath.row) {
                model.toggleSelection(at: indexPath.row)
                tableView.reloadData()
            } else {
                presentRemoveSelectionAlert(toMakeRoomFor: indexPath.row)
            }
        } else {
            model.toggleSelection(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
