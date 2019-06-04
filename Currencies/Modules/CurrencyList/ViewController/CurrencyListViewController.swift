//
//  AppDelegate.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    lazy var viewModel: CurrencyListViewModel = {
        return CurrencyListViewModel()
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.initFetch()
    }
    
    // MARK: - User Interaction
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell else {
            
            return UITableViewCell()
        }
        
        let cellModel = viewModel.getCellViewModel(at: indexPath)
        cell.configureWithCellModel(cellModel)
        
        return cell
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.userPressed(at: indexPath)
    }
    
    // MARK: - Helpers
    
    private func initViewModel() {
        // * showAlertClosure
        viewModel.showAlertClosure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
        
        // * reloadTableViewClosure
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            } 
        }
        
        // * showComparableCurrenciesScreen
        viewModel.showComparableCurrenciesScreen = { [weak self] (indexPath) in
            guard let self = self else { return }
            
            let viewModel = self.viewModel.getModelForComparableCurrenciesListVC(forRowAt: indexPath)
            let comparableCurrenciesVC = ComparableCurrencyListViewController.init(viewModel: viewModel)
            self.show(comparableCurrenciesVC!, sender: nil)
        }
    }
}

// MARK: - Receiver

extension CurrencyListViewController: Receiver {
    func receive(_ pairs: [Pair]) {
        viewModel.receive(pairs)
    }
}























