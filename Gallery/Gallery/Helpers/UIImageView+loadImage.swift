//
//  UIImageView+loadImage.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(with url: String, completion: @escaping (() -> ())) {
        guard let url = URL(string: url) else { return }
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion()
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: url as AnyObject)
                self.image = imageToCache
                completion()
            }
        }.resume()
    }
}
