//
//  UIView + Ext.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/26/24.
//

import Foundation
import UIKit
extension UIView {
    
    func pinToEdges(to superView: UIView, with constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant).isActive = true
    }
}
