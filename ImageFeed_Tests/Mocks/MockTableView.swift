//
//  MockTableView.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import UIKit

class MockTableView: UITableView {
    var mockIndexPath: IndexPath?
    
    override func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return mockIndexPath
    }
}
