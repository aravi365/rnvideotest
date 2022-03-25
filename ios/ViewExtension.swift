//
//  ViewExtension.swift
//  react-native-ps-video
//
//  Created by Mzalih on 03/02/22.
//

import Foundation
extension UIView {

    func constrainToParent(with insets: UIEdgeInsets = .zero) {

        guard let parentView = superview else { return  }

        translatesAutoresizingMaskIntoConstraints = false

        let top = topAnchor.constraint(equalTo: parentView.topAnchor, constant: insets.top)
        let bottom = parentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)
        let left = leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: insets.left)
        let right = parentView.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right)

        NSLayoutConstraint.activate([top, bottom, left, right])

    }
    func setDimensions(width: CGFloat? = nil, height: CGFloat? = nil) {
            translatesAutoresizingMaskIntoConstraints = false
            if let width = width {
                widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            if let height = height {
                heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
}
