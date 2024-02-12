//
//  DetailScreenPresenter.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import Foundation

// MARK: - DetailScreenPresenterProtocol

protocol DetailScreenPresenterProtocol {
    func prepareInitialData()
    func likeTapped()
}

// MARK: - DetailScreenPresenter

final class DetailScreenPresenter {
    
    // MARK: - Private properties
    
    private var imageResource: ImageResponse
    private let databaseManager: DatabaseManager
    
    // MARK: - Dependency
    
    weak var viewController: DetailScreenViewProtocol?
    
    // MARK: - Init
    
    init(imageResource: ImageResponse, databaseManager: DatabaseManager = .shared ) {
        self.imageResource = imageResource
        self.databaseManager = databaseManager
    }
}

// MARK: - Extensions

extension DetailScreenPresenter: DetailScreenPresenterProtocol {
    func likeTapped() {
        imageResource.isLiked ?? false ? databaseManager.removeImage(imageId: imageResource.id) : databaseManager.addImage(imageId: imageResource.id)
        imageResource.isLiked?.toggle()
        viewController?.updateButtonState(isLiked: imageResource.isLiked ?? false)
    }
    
    func prepareInitialData() {
        viewController?.fillInitialData(
            imageUrl: imageResource.urls.full,
            description: imageResource.altDescription,
            isLiked: imageResource.isLiked ?? false
        )
    }
}
