//
//  ListOfPairsViewModel.swift
//  Currencies
//
//  Created by Artem Lytkin on 28/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

struct PairListCellViewModel {
    let titleText: String
    let decriptionText: String
    let secondaryText: String
    var value: String
}

class PairListViewModel {
    
    let apiService: PairsServiceProtocol
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    private var pairs: [Pair] = [] {
        didSet { 
            reloadTableViewClosure?()
        }
    }
    
    private var cellViewModels: [PairListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var numberOfSections = 2
    
    // MARK: - Binding
    
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(apiService: PairsServiceProtocol = PairsService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func calledSegue(to viewController: Any) {
        guard let receiver = viewController as? Receiver
            else { return }
        
        receiver.receive(pairs)
    }
    
    public func receive(_ data: Any) {
        if let pairList = data as? [Pair] {
            self.processFetchedPairs(pairList)
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> PairListCellViewModel {
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
    }
    
    public func getCellHeight(at indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        
        return 80
    }
    
    public func isTopCell(at indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    public func getNumberOfCells(in section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return pairs.count
    }
    
    // MARK: - Private
    
    private func fetchPairs(_ pairs: [Pair]) {

        let pairNames: [String] = pairs.map {
            return $0.main.shortName + $0.secondary.shortName
        }
        
        apiService.fetchPairsList(pairNames: pairNames) {[weak self] (pairs, error) in
            guard error == nil,
                let unwrappedPairs = pairs else {
                    
                    self?.alertMessage = error.debugDescription
                    return
            }
            
            self?.pairs = unwrappedPairs
        }
    }
    
    private func processFetchedPairs(_ pairs: [Pair]) {
        self.pairs.append(contentsOf: pairs)
        
        for pair in pairs {
            let mainCurrency = pair.main
            let secondaryCurrency = pair.secondary
            let titleText = "1 " + mainCurrency.shortName
            let secondaryText = secondaryCurrency.longName + " - " + secondaryCurrency.shortName
            let value = String(pair.coefficient)
            let pairListCellViewModel = PairListCellViewModel(titleText: titleText,
                                                                  decriptionText: mainCurrency.longName,
                                                                  secondaryText: secondaryText,
                                                                  value: value)
            cellViewModels.append(pairListCellViewModel)
        }
    }
    
}
