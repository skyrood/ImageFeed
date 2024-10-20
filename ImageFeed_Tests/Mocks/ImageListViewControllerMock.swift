//
//  ImageListViewControllerMock.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import ImageFeed
import UIKit

final class ImageListViewControllerMock: ImageListViewControllerProtocol {
    var photos: [Photo] = []
    
    var presenter: (any ImageFeed.ImageListPresenterProtocol)?
    
    var tableView: UITableView!
    
    var didCallUpdateTableViewAnimated = false
    
    init() {
        tableView = UITableView()
    }
    
    func updateTableViewAnimated() {
        didCallUpdateTableViewAnimated = true
    }
}
