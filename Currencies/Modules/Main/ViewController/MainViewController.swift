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
        
        viewModel.showAlertClosure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
        
        viewModel.initData()
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        // There is a seque to return back in MainViewController from ComparableCurrenciesListViewController, PairListViewController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewModel.didSelect(viewController: viewController)
    }
}

extension MainViewController: PairsFetcher {
    func fetchPair(first: Currency, second: Currency) {
        viewModel.fetchPair(first: first, second: second)
    }
}
