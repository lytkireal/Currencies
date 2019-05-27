//
//  ViewController.swift
//  Revolut
//
//  Created by Artem Lytkin on 20.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import UIKit

class CurrenciesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    lazy var viewModel: CurrenciesListViewModel = {
        return CurrenciesListViewModel()
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier(), for: indexPath) as? CurrencyTableViewCell else {
            
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
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        // * reloadTableViewClosure
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            } 
        }
        
        // * showComparableCurrenciesScreen
        viewModel.showComparableCurrenciesScreen = { [weak self] in
            guard let self = self else { return }
            
            let viewModel = self.viewModel.getModelForComparableCurrenciesListVC()
            let comparableCurrenciesVC = ComparableCurrenciesListViewController.init(viewModel: viewModel)
            self.show(comparableCurrenciesVC!, sender: nil)
        }
        
        viewModel.initFetch()
    }
    
    private func showAlert( _ message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

























