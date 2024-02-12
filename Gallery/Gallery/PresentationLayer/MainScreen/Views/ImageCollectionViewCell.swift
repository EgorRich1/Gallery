//
//  ImageCollectionViewCell.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import UIKit

// MARK: - ImageCollectionViewCell

final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subview properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .red
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        contentView.addSubview(imageView, activate: [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        imageView.addSubview(likeImageView, activate: [
            likeImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 4),
            likeImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4),
            likeImageView.widthAnchor.constraint(equalToConstant: 12),
            likeImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    // MARK: - Public methods
    
    func configure(url: String, isLiked: Bool) {
        imageView.loadImage(with: url) {}
        likeImageView.isHidden = !isLiked
    }
}
