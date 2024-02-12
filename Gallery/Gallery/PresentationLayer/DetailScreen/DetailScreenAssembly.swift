//
//  DetailScreenAssembly.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import UIKit

// MARK: - MainScreenAssembly

final class DetailScreenAssembly {
    
    class func assembly(imageResource: ImageResponse, pageIndex: Int) -> UIViewController {
        let presenter = DetailScreenPresenter(imageResource: imageResource)
        let viewController = DetailScreenViewController(pageIndex: pageIndex, presenter: presenter)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
