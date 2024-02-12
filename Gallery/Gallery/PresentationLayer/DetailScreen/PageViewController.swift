//
//  PageViewController.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import UIKit

// MARK: - PageViewControllerDelegate

protocol PageViewControllerDelegate: AnyObject {
    func viewControllerWillClose()
}

// MARK: - PageViewController

final class PageViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let images: [ImageResponse]
    private var currentIndex: Int
    
    // MARK: - Public properties
    
    weak var delegate: PageViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(images: [ImageResponse], currentIndex: Int) {
        self.images = images
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        let startViewController = createViewController(for: currentIndex)
        pageViewController.setViewControllers([startViewController], direction: .forward, animated: false)
        addChild(pageViewController)
        view.addSubview(pageViewController.view, activate: [
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        pageViewController.didMove(toParent: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.viewControllerWillClose()
    }
    
    // MARK: - Private methods
    
    private func createViewController(for index: Int) -> UIViewController {
        let viewController = DetailScreenAssembly.assembly(imageResource: images[index], pageIndex: index)
        return viewController
    }
}

// MARK: - Extensions

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? DetailScreenViewController)?.getIndex() else { return nil }
        if index == .zero {
            return nil
        }
        return createViewController(for: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? DetailScreenViewController)?.getIndex() else { return nil }
        if index == images.count {
            return nil
        }
        return createViewController(for: index + 1)
    }
}
