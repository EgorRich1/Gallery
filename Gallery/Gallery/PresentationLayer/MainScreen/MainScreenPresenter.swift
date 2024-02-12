//
//  MainScreenPresenter.swift
//  Gallery
//
//  Created by Егор Ярошук on 10.02.24.
//

import Foundation

// MARK: - MainScreenPresenterProtocol

protocol MainScreenPresenterProtocol {
    func loadInitialData()
    func loadNextPage()
    func checkForUpdates()
}

// MARK: - MainScreenPresenter

final class MainScreenPresenter {
    
    // MARK: - Private properties
    
    private let apiManager: ApiManager
    private let databaseManager: DatabaseManager
    private var currentPage = 1
    private var loadedImages = [ImageResponse]()
    
    // MARK: - Dependency
    
    weak var viewController: MainScreenViewProtocol?
    
    // MARK: - Init
    
    init(apiManager: ApiManager = .shared, databaseManager: DatabaseManager = .shared) {
        self.apiManager = apiManager
        self.databaseManager = databaseManager
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        apiManager.loadProtos(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    var images = [ImageResponse]()
                    response.forEach { image in
                        let image = ImageResponse(
                            id: image.id,
                            description: image.description,
                            altDescription: image.altDescription,
                            urls: image.urls,
                            isLiked: self.databaseManager.getStoredImages().contains(where: {$0 == image.id})
                        )
                        images.append(image)
                    }
                    if self.currentPage > 1 {
                        var indexes = [IndexPath]()
                        for row in images.indices {
                            indexes.append(.init(row: self.loadedImages.count + row, section: .zero))
                        }
                        self.viewController?.appendRows(indixes: indexes, images: images)
                    } else {
                        self.viewController?.addNewImages(images: images, isShouldUpdateDatasource: false)
                    }
                    self.loadedImages.append(contentsOf: images)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.viewController?.showError(with: "Error", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Extensions

extension MainScreenPresenter: MainScreenPresenterProtocol {
    func checkForUpdates() {
        var images = [ImageResponse]()
        loadedImages.forEach { image in
            let image = ImageResponse(
                id: image.id,
                description: image.description,
                altDescription: image.altDescription,
                urls: image.urls,
                isLiked: self.databaseManager.getStoredImages().contains(where: {$0 == image.id})
            )
            images.append(image)
        }
        loadedImages = images
        viewController?.addNewImages(images: loadedImages, isShouldUpdateDatasource: true)
    }
    
    func loadInitialData() {
        loadData()
    }
    
    func loadNextPage() {
        currentPage += 1
        loadData()
    }
}
