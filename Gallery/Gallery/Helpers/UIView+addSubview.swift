//
//  UIView+addSubview.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import UIKit

extension UIView {
    func addSubview(_ subview: UIView, activate: [NSLayoutConstraint]) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(activate)
    }
}
