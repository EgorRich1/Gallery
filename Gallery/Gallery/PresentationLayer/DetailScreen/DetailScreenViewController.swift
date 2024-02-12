//
//  DetailScreenViewController.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import UIKit

// MARK: - DetailScreenViewProtocol

protocol DetailScreenViewProtocol: AnyObject {
    func fillInitialData(imageUrl: String, description: String, isLiked: Bool)
    func updateButtonState(isLiked: Bool)
}

// MARK: - DetalScreenViewController

final class DetailScreenViewController: UIViewController {
    
    // MARK: - Subview properties
    private let loadingContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private properties
    
    private let pageIndex: Int
    private let presenter: DetailScreenPresenterProtocol
    
    // MARK: - Lifecycle
    
    init(pageIndex: Int, presenter: DetailScreenPresenterProtocol) {
        self.pageIndex = pageIndex
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadingContainer.isHidden = false
        loadingIndicator.startAnimating()
        presenter.prepareInitialData()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView, activate: [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        view.addSubview(loadingContainer, activate: [
            loadingContainer.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingContainer.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            loadingContainer.widthAnchor.constraint(equalToConstant: 80),
            loadingContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        loadingContainer.addSubview(loadingIndicator, activate: [
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor)
        ])
        view.addSubview(descriptionLabel, activate: [
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        view.addSubview(heartButton, activate: [
            heartButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            heartButton.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 8),
            heartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            heartButton.heightAnchor.constraint(equalToConstant: 24),
            heartButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func heartTapped() {
        presenter.likeTapped()
    }
    
    // MARK: - Public methods
    
    func getIndex() -> Int {
        pageIndex
    }
}

// MARK: - Extensions

extension DetailScreenViewController: DetailScreenViewProtocol {
    func updateButtonState(isLiked: Bool) {
        heartButton.tintColor = isLiked ? .red : .black
    }
    
    func fillInitialData(imageUrl: String, description: String, isLiked: Bool) {
        descriptionLabel.text = description
        imageView.loadImage(with: imageUrl) { [weak self] in
            self?.loadingContainer.isHidden = true
            self?.loadingIndicator.stopAnimating()
        }
        heartButton.tintColor = isLiked ? .red : .black
    }
}
