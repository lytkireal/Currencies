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
    
    // MARK: - Public Properties
    
    public var numberOfSections = 2
    
    // MARK: - Private Properties
    
    private let apiService: PairsServiceProtocol
    
    private var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    private var pairs: [Pair] = [] {
        didSet {
            updateCellViewModels(with: pairs)
        }
    }
    
    private var cellViewModels: [PairListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    private var timer = Timer()
    
    // MARK: - Binding
    
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(apiService: PairsServiceProtocol = PairsService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func startEngine() {
        startTimer()
    }
    
    public func calledSegue(to viewController: Any) {
        guard let receiver = viewController as? Receiver
            else { return }
        
        receiver.receive(pairs)
    }
    
    public func receive(_ data: Any) {
        if let pairList = data as? [Pair] {
            self.processAddedPairs(pairList)
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
    
    public func removeAction(at indexPath: IndexPath){
        pairs.remove(at: indexPath.row)
    }
    
    public func beginEditingAction() {
        timer.invalidate()
    }
    
    public func endEditingAction() {
        startTimer()
    }
    
    // MARK: - Private
    
    private func startTimer() {
        // Start timer with interval 1 s:
        timer = Timer.scheduledTimer(timeInterval: Network.updatingInterval,
                                     target: self,
                                     selector: #selector(fetchPairs),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc
    private func fetchPairs() {

        let pairNames: [String] = pairs.map {
            return $0.main.shortName + $0.secondary.shortName
        }
        
        apiService.fetchPairsList(pairNames: pairNames) {[weak self] (pairs, error) in
            guard error == nil,
                let unwrappedPairs = pairs else {
                    
                    self?.alertMessage = error.debugDescription
                    return
            }
            
            self?.udpateCoefficients(with: unwrappedPairs)
        }
    }
    
    private func udpateCoefficients(with fetchedPairs: [Pair]) {
        pairsLoop: for (indexInArray, pair) in pairs.enumerated() {
            for fetchedPair in fetchedPairs {
                if pair.main == fetchedPair.main, pair.secondary == fetchedPair.secondary {
                    pairs[indexInArray] = fetchedPair
                    continue pairsLoop
                }
            }
        }
    }
    
    private func updateCellViewModels(with pairs: [Pair]) {
        
        let cellViewModels = createCellViewModels(pairs: pairs)
        self.cellViewModels = cellViewModels
    }
    
    private func processAddedPairs(_ pairs: [Pair]) {
        self.pairs.append(contentsOf: pairs)
    }
    
    private func createCellViewModels(pairs: [Pair]) -> [PairListCellViewModel] {
        var cellViewModels: [PairListCellViewModel] = []
        
        for pair in pairs {
            let mainCurrency = pair.main
            let secondaryCurrency = pair.secondary
            let titleText = "1 " + mainCurrency.shortName
            let secondaryText = secondaryCurrency.longName + " / " + secondaryCurrency.shortName
            let value = String(pair.coefficient)
            let pairListCellViewModel = PairListCellViewModel(titleText: titleText,
                                                              decriptionText: mainCurrency.longName,
                                                              secondaryText: secondaryText,
                                                              value: value)
            cellViewModels.append(pairListCellViewModel)
        }
        
        return cellViewModels
    }
}
