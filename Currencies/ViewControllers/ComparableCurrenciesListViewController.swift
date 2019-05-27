//
//  ComparableCurrenciesListViewController.swift
//  Currencies
//
//  Created by macbook air on 26/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit



class ComparableCurrenciesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel: ComparableCurrenciesListViewModel!
    
    // MARK: - Lifecycle
    
    static func `init`(viewModel: ComparableCurrenciesListViewModel) -> ComparableCurrenciesListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ComparableCurrenciesListViewController.self)) as? ComparableCurrenciesListViewController
        vc?.viewModel = viewModel
        vc?.initViewModel()
        return vc
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = viewModel.getCellViewModel(at: indexPath)
        if cellModel.isSelected {
            cell.setSelected(true, animated: false)
        }
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    private func showAlert( _ message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}


























