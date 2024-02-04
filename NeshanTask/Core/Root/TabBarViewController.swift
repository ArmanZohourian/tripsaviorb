//
//  TabBarViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/22/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
}


private extension TabBarViewController {
    
    private func setupTabs() {
        self.tabBar.backgroundColor = .black
        let exploreView = self.createNav(with: "Explore", image: UIImage(systemName: "map"), vc: ExploreViewController())
        let tripsView = self.createNav(with: "Trips", image: UIImage(systemName: "bookmark"), vc: TripsViewController())
        self.setViewControllers([exploreView,tripsView], animated: true)
    }
    
    private func createNav(with title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}
