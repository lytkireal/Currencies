//
//  ComparableCurrenciesListViewController.swift
//  Currencies
//
//  Created by macbook air on 26/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit



class ComparableCurrenciesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CurrencyTableViewCellDelegate {

    static func `init`(viewModel: ComparableCurrenciesListViewModel) -> ComparableCurrenciesListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ComparableCurrenciesListViewController.self)) as? ComparableCurrenciesListViewController
        vc?.viewModel = viewModel
        vc?.initViewModel()
        return vc
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel: ComparableCurrenciesListViewModel!
    
    // MARK: - Lifecycle
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier(), for: indexPath) as? CurrencyTableViewCell
        
        // 2 Check that cell is registered and currencies array is not nil:
        guard let currencyCell = cell else {
            print("CurrencyTableViewCell doesn't register in table view.")
            return UITableViewCell()
        }
        
        let cellModel = viewModel.getCellViewModel(at: indexPath)
        currencyCell.configureWithCellModel(cellModel)
        currencyCell.delegate = self
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
        return currencyCell
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        // guard viewModel.isAllowToTapOnCell else {
        //   return nil
        // }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //  guard viewModel.isAllowToTapOnCell else {
        //      return
        //  }
        
        viewModel.userPressed(at: indexPath)
    }
    
    // MARK: - CurrencyTableViewCellDelegate
    
    func currencyTableViewCellDelegate(_ currencyShortName: String, newValueOfCurrency: String) {
        //viewModel.userChangedValueFor(name: currencyShortName, withValue: newValueOfCurrency)
    }
    
    func currencyValueDidBeginEditing() {
        
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


























