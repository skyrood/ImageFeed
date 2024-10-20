//
//  ImageListViewTests.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import XCTest
@testable import ImageFeed

final class ImageListViewTests: XCTestCase {
    
    let photoResultMock = PhotoResult(
        id: "123",
        width: 456,
        height: 789,
        createdAt: "",
        description: "A beautiful scenery",
        urls: UrlsResult(
            raw: "http://unsplash.com/raw.jpg",
            full: "http://unsplash.com/full.jpg",
            regular: "http://unsplash.com/regular.jpg",
            small: "http://unsplash.com/small.jpg",
            thumb: "http://unsplash.com/thumb.jpg"
        ),
        isLiked: false
    )
    
    var samplePhotoMock: Photo {
        return Photo(from: photoResultMock)
    }
    
    func testLoadPhotosCallsUpdateTableViewAnimated() {
        //given
        let imageListServiceMock = ImageListServiceMock()
        let viewMock = ImageListViewControllerMock()
        let presenter = ImageListPresenter(imageListService: imageListServiceMock)
        presenter.view = viewMock
        
        //when
        presenter.loadPhotos()
        
        //then
        XCTAssertTrue(viewMock.didCallUpdateTableViewAnimated)
    }
    
    func testLoadNextPhotosCallsLoadPhotosWhenLastRowIsDisplayed() {
        //given
        let imageListServiceMock = ImageListServiceMock()
        let presenter = ImageListPresenter(imageListService: imageListServiceMock)
        
        let photos = [samplePhotoMock]
        imageListServiceMock.photos = photos
        
        let lastIndexPath = IndexPath(row: photos.count - 1, section: 0)
        
        //when
        presenter.loadNextPhotos(forRowAt: lastIndexPath)
        
        //then
        XCTAssertTrue(imageListServiceMock.didCallFetchPhotosNextPage)
    }
    
    func testLikeButtonTappingUpdatesLikeImage() {
        // given
        let imageListServiceMock = ImageListServiceMock()
        let presenter = ImageListPresenter(imageListService: imageListServiceMock)
        let view = ImageListViewControllerMock()
        
        let mockTableView = MockTableView()
        view.tableView = mockTableView
        presenter.view = view
        
        presenter.photos.append(samplePhotoMock)
        
        view.tableView.register(MockImageListCell.self, forCellReuseIdentifier: ImageListCell.reuseIdentifier)
        
        let indexPath = IndexPath(row: 0, section: 0)
        mockTableView.mockIndexPath = indexPath
        
        view.tableView.reloadData()
        
        let cell = view.tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath) as! MockImageListCell
        cell.configure(with: samplePhotoMock, delegate: presenter)
        
        // when
        presenter.didTapLikeButton(in: cell)
        
        // then
        XCTAssertTrue(imageListServiceMock.didTriggerChangeLike)
        print("\(cell.isLiked), \(samplePhotoMock.isLiked)")
    }
    
    func testPrepareCellConfiguresCellCorrectly() {
        // given
        let imageListServiceMock = ImageListServiceMock()
        let presenter = ImageListPresenter(imageListService: imageListServiceMock)
        let view = ImageListViewControllerMock()
        presenter.view = view
        
        imageListServiceMock.photos.append(samplePhotoMock)
        
        view.tableView.register(MockImageListCell.self, forCellReuseIdentifier: ImageListCell.reuseIdentifier)
        
        let indexPath = IndexPath(row: 0, section: 0)
        view.tableView.reloadData()
        
        // when
        let cell = presenter.prepareCell(view.tableView, for: indexPath) as? MockImageListCell
        
        // then
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.photoId, "123")
        XCTAssertEqual(cell?.isLiked, false)
        XCTAssertEqual(cell?.descriptionLabel.text, "A beautiful scenery")
    }
    
    func testImageHeightCalculation() {
        //given
        let imageListServiceMock = ImageListServiceMock()
        let presenter = ImageListPresenter(imageListService: imageListServiceMock)
        
        presenter.photos.append(samplePhotoMock)
        
        let tableViewWidth: CGFloat = 375.0
        
        //when
        let indexPath = IndexPath(row: 0, section: 0)
        let calculatedHeight = presenter.calculateImageHeight(for: indexPath, tableViewWidth: tableViewWidth)
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageContainerWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let expectedHeight = imageContainerWidth * samplePhotoMock.size.height / samplePhotoMock.size.width + imageInsets.top + imageInsets.bottom
        
        //then
        XCTAssertEqual(calculatedHeight, expectedHeight, accuracy: 0.01)
    }
}
