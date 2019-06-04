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
    
    // MARK: - Model
    
    private let apiService: PairServiceProtocol
    
    private var pairs: [Pair] = [] {
        didSet {
            if pairs.isEmpty {
                backToEmptyScreen?()
            }
        }
    }
    
    private var cellViewModels: [PairListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    // MARK: - Public Properties
    
    public var numberOfSections = 2
    
    // MARK: - Private Properties
    
    private let queue = DispatchQueue(label: "com.lytkinreal.currencies.pairs_list_service_array_queue", attributes: .concurrent)
    
    private var alertMessage: String? {
        didSet {
            guard let message = alertMessage else { return }
            showAlertClosure?(message)
        }
    }

    private var timer = Timer()
    
    // MARK: - Binding
    
    var tableDeleteRowsClosure: TableViewRemoveRowsClosure?
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: ErrorClosure?
    var backToEmptyScreen: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(apiService: PairServiceProtocol = PairService()) {
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
    
    public func getCellViewModel(at indexPath: IndexPath) -> PairListCellViewModel? {
        var cellViewModel: PairListCellViewModel?
        
        queue.sync {
            cellViewModel = cellViewModels[indexPath.row]
        }
        
        return cellViewModel
    }
    
    public func getCellHeight(at indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
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
        queue.async(flags: .barrier) {
            self.pairs.remove(at: indexPath.row)
        }
        apiService.removePair(pairs[indexPath.row])
        tableDeleteRowsClosure?([indexPath])
    }
    
    public func beginEditingAction() {
        timer.invalidate()
        apiService.cancelRequests()
    }
    
    public func endEditingAction() {
        self.startTimer()
    }
    
    @objc
    public func viewDidDisappear() {
        print("viewDidDisappear")
        apiService.savePairs(pairs)
    }
    
    // MARK: - Private
    
    private func startTimer() {
        // Start timer with interval 1 s:
        timer = Timer.scheduledTimer(timeInterval: Network.updatingInterval,
                                     target: self,
                                     selector: #selector(updatePairs),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    @objc
    private func updatePairs() {
        
        var pairNames: [String] = []
        
        queue.sync {
            pairNames = pairs.compactMap {
                return $0.main.shortName + $0.secondary.shortName
            }
        }
        
        apiService.fetchNewValues(for: pairNames) {[weak self] pairPayloadList, error in
            guard error == nil,
                let unwrappedPairPayloadList = pairPayloadList else {
                    
                    if let errorMessage = error?.rawValue {
                        self?.alertMessage = errorMessage
                    }
                    
                    return
            }
            
            self?.udpateCoefficients(withPayload: unwrappedPairPayloadList)
        }
    }
    
    private func udpateCoefficients(withPayload payload: [PairPayload]) {
        
        pairsLoop: for (indexInArray, pair) in pairs.enumerated() {
            for pairPayload in payload {
                if pair.main == pairPayload.main,
                    pair.secondary == pairPayload.secondary {
                    
                    pairs[indexInArray].coefficient = pairPayload.coefficient
                    continue pairsLoop
                }
            }
        }
        
        updateCellViewModels(with: pairs)
    }
    
    private func updateCellViewModels(with pairs: [Pair]) {
        queue.async(flags: .barrier) {
            let cellViewModels = self.createCellViewModels(pairs: pairs)
            self.cellViewModels = cellViewModels
        }
    }
    
    private func processAddedPairs(_ pairs: [Pair]) {
        queue.async(flags: .barrier) {
            self.pairs.append(contentsOf: pairs)
            self.updateCellViewModels(with: self.pairs)
        }
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
