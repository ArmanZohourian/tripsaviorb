//
//  UIViewController + topOfViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/31/24.
//

import Foundation
extension UIViewController {
    func topViewController() -> UIViewController {
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topViewController() ?? self
        } else if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController() ?? self
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.topViewController()
        } else {
            return self
        }
    }
}
