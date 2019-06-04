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

protocol SynchronizedArrayDelegate: AnyObject {
    func arrayChanged(isEmpty: Bool)
}

class SynchronizedArray<T> {
    
    weak var delegate: SynchronizedArrayDelegate?
    private let queue = DispatchQueue(label: "com.lytkinreal.currencies.pairs_list_service_array_queue", attributes: .concurrent)
    private var array: [T] = [] {
        didSet {
            delegate?.arrayChanged(isEmpty: array.isEmpty)
        }
    }
    
    public var isEmpty: Bool {
        var isEmpty = true
        queue.sync {
            isEmpty = self.array.isEmpty
        }
        return isEmpty
    }
    
    
    public var count: Int {
        var count = 0
        queue.sync {
            count = self.array.count
        }
        return count
    }
    
    public var allValues: [T] {
        var values: [T] = []
        queue.sync {
            values = self.array
        }
        return values
    }
    
    public func append(_ newElement: T) {
        queue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    public func append(contentsOf sequence: [T]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: sequence)
        }
    }
    
    public func remove(at index: Int) -> T {
        var element: T!
        
        queue.sync {
            element = self.array.remove(at: index)
        }
        
        return element
    }
    
    public func first() -> T? {
        var element: T?
        
        self.queue.sync {
            element = self.array.first
        }
        
        return element
    }
    
    public func map<S>(_ transform: (T) -> S) -> [S] {
        let result = self.array.map { (element) -> S in
            transform(element)
        }
        
        return result
    }
    
    public func enumerated() -> EnumeratedSequence<[T]> {
        var enumeratedSequence: EnumeratedSequence<[T]>!
        
        queue.sync {
            enumeratedSequence = self.array.enumerated()
        }
        
        return enumeratedSequence
    }
    
    subscript(index: Int) -> T {
        set {
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            
            queue.sync {
                element = array[index]
            }
            
            return element
        }
    }
}

class PairListViewModel {
    
    // MARK: - Model
    
    private let apiService: PairServiceProtocol
    
    private lazy var pairs = SynchronizedArray<Pair>()
    
    private var cellViewModels: [PairListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    // MARK: - Public Properties
    
    public var numberOfSections = 2
    
    // MARK: - Private Properties
    
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
        pairs.delegate = self
    }
    
    // MARK: - Public
    
    public func startEngine() {
        timer.invalidate()
        startTimer()
    }
    
    public func calledSegue(to viewController: Any) {
        guard let receiver = viewController as? Receiver
            else { return }
        
        receiver.receive(pairs.allValues)
    }
    
    public func receive(_ data: Any) {
        if let pairList = data as? [Pair] {
            self.processAddedPairs(pairList)
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> PairListCellViewModel? {
        var cellViewModel: PairListCellViewModel?
    
        cellViewModel = cellViewModels[indexPath.row]
        
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
        var count = 0
        
        if section == 0 {
            return 1
        }
        
        count = self.pairs.count
        
        return count
    }
    
    public func removeAction(at indexPath: IndexPath){
        let removalPair = self.pairs.remove(at: indexPath.row)
        self.apiService.removePair(removalPair)

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
        timer.invalidate()
        
        apiService.savePairs(pairs)
    }
    
    public func viewWillAppear() {
        startEngine()
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
        
        pairNames = pairs.map {
            return $0.main.shortName + $0.secondary.shortName
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
    
    private func updateCellViewModels(with pairs: SynchronizedArray<Pair>) {
        let cellViewModels = self.createCellViewModels(pairs: pairs)
        self.cellViewModels = cellViewModels
    }
    
    private func processAddedPairs(_ pairs: [Pair]) {
        self.pairs.append(contentsOf: pairs)
        self.updateCellViewModels(with: self.pairs)
    }
    
    private func createCellViewModels(pairs: SynchronizedArray<Pair>) -> [PairListCellViewModel] {
        var cellViewModels: [PairListCellViewModel] = []
        
        let count = pairs.count
        
        for i in 0...count - 1 {
            let pair = pairs[i]
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

extension PairListViewModel: SynchronizedArrayDelegate {
    func arrayChanged(isEmpty: Bool) {
        if isEmpty { backToEmptyScreen?() }
    }
}
