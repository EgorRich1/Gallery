//
//  MainScreenViewController.swift
//  Gallery
//
//  Created by Егор Ярошук on 10.02.24.
//

import UIKit

// MARK: - MainScreenViewProtocol

protocol MainScreenViewProtocol: AnyObject {
    func appendRows(indixes: [IndexPath], images: [ImageResponse])
    func addNewImages(images: [ImageResponse], isShouldUpdateDatasource: Bool)
    func showError(with title: String, and message: String)
}

// MARK: - MainScreenViewController

final class MainScreenViewController: UIViewController {
    
    // MARK: - Subview properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Images"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: 116, height: 116)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentMode = .topLeft
        return collectionView
    }()
    
    // MARK: - Private properties
    
    private let presenter: MainScreenPresenterProtocol
    private var images = [ImageResponse]()
    private var isLoading = false
    
    // MARK: - Lifecycle
    
    init(presenter: MainScreenPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.loadInitialData()
        isLoading = true
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel, activate: [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
        view.addSubview(collectionView, activate: [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Extensions

extension MainScreenViewController: MainScreenViewProtocol {
    func showError(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func appendRows(indixes: [IndexPath], images: [ImageResponse]) {
        self.images.append(contentsOf: images)
        collectionView.insertItems(at: indixes)
        isLoading = false
    }
    
    func addNewImages(images: [ImageResponse], isShouldUpdateDatasource: Bool) {
        if isShouldUpdateDatasource {
            self.images = images
        } else {
            self.images.append(contentsOf: images)
        }
        isLoading = false
        collectionView.reloadData()
    }
}

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(url: images[indexPath.row].urls.thumb, isLiked: images[indexPath.row].isLiked ?? false)
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == images.count - 4, !isLoading {
            isLoading = true
            presenter.loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PageViewController(images: images, currentIndex: indexPath.row)
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension MainScreenViewController: PageViewControllerDelegate {
    func viewControllerWillClose() {
        presenter.checkForUpdates()
    }
}
