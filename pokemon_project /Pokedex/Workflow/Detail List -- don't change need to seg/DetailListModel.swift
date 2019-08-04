import Foundation
import struct UIKit.CGFloat

final class DetailListModel {
    let details: [Detail]
    let rowHeight: CGFloat = 64.0
    
    init(details: [Detail]) {
        self.details = details
    }
}
