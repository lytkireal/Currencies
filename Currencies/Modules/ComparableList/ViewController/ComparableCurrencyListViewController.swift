//
//  ComparableCurrenciesListViewController.swift
//  Currencies
//
//  Created by macbook air on 26/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

class ComparableCurrencyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel: ComparableCurrencyListViewModel!
    
    // MARK: - Lifecycle
    
    static func `init`(viewModel: ComparableCurrencyListViewModel) -> ComparableCurrencyListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ComparableCurrencyListViewController.self)) as? ComparableCurrencyListViewController
        vc?.viewModel = viewModel
        vc?.initViewModel()
        return vc
    }
    
    // MARK: - View Lifecycle

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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.calledSegue(to: segue.destination)
    }
    
    // MARK: - Helpers
    
    private func initViewModel() {
        
        // * sendPairsClosure
        viewModel.sendPairsClosure = { [weak self] in
            // This segue is declared in MainViewController.swift;
            // You can find its identifier in Main.storyboard -> Document Outline -> Comparable currencies Scene -> Unwind segue at bottom.
            self?.performSegue(withIdentifier: "BackToPairsScreenSegue", sender: nil)
        }
        
        // * showAlertClosure
        viewModel.showAlertClosure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
    }
}


























