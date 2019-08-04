import Foundation

final class SelectionListModel {
    let options: [Selection]
    let selectionType: Selection.DataType
    private var selectedIndexes: [Int]
    
    var hasReachedMaximumSelectionCount: Bool {
        return selectedIndexes.count == selectionType.maximumSelectionCount
    }

    var selections: [(index: Int, option: Selection)] {
        return selectedIndexes.map { ($0, options[$0]) }
    }
    
    init(options: [Selection],  selectionType: Selection.DataType, selectedTitles: [String]) {
        self.options = options
        self.selectionType = selectionType
        selectedIndexes = selectedTitles.compactMap { title in
            return options.enumerated().first {$0.element.title == title }?.offset
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedIndexes.contains(index)
    }
    
    func toggleSelection(at index: Int) {
        if isSelected(at: index) {
            selectedIndexes = selectedIndexes.filter { $0 != index }
        } else {
            selectedIndexes.append(index)
        }
    }
}
