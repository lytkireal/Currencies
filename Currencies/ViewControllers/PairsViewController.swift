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

class PairsViewController: UITabBarController {

    lazy var viewModel: PairsViewModel = {
        return PairsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isHidden = true
        
        viewModel.initFetch()
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        print(segue.source)
        print(segue.destination)
    }
}

extension PairsViewController: PairsFetcher {
    func fetchPair(first: Currency, second: Currency) {
        viewModel.fetchPair(first: first, second: second)
    }
}
