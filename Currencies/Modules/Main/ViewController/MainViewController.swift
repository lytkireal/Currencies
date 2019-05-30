//
//  MainViewController.swift
//  Currencies
//
//  Created by Artem Lytkin on 27/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

protocol PairsFetcher {
    func fetchPair(first: Currency, second: Currency)
}

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        self.tabBar.isHidden = true
        
        viewModel.showPairListScreen = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vcIndex = self.viewModel.pairListVCIndex
                let vc = self.children[vcIndex]
                self.selectedViewController = vc
                self.tabBarController(self, didSelect: vc)
            }
        }
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        //print(segue.source)
        //print(segue.destination)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewModel.didSelect(viewController: viewController)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        print("present")
    }
}

extension MainViewController: PairsFetcher {
    func fetchPair(first: Currency, second: Currency) {
        viewModel.fetchPair(first: first, second: second)
    }
}
