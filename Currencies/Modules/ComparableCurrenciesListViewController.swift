//
//  ComparableCurrenciesListViewController.swift
//  Currencies
//
//  Created by macbook air on 26/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

class ComparableCurrenciesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CurrencyTableViewCellDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    lazy var viewModel: ComparableCurrenciesListViewModel = {
        return ComparableCurrenciesListViewModel(currencies: <#[Currency]#>)
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
        initViewModel()
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
        // 1 - showAlertClosure
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        // 2 - updateLoadingStatus
        viewModel.updateLoadingStatusClosure = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    //self?.activityView.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        //self?.tableView.alpha = 0.0
                    })
                } else {
                    //self?.activityView.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        //self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        // 3 - reloadTableViewClosure
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        // 4 - tapOnCellClosure
        
        viewModel.tapOnCellClosure = { [weak self] selectedCells in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.show(self, sender: nil)
                //selectedCells.forEach {
                //                    self?.tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
                //              }
            }
        }
        
        // 5 - moveCellToTopClosure
        viewModel.moveCellToTopClosure = { [weak self] (indexPath: IndexPath) in
            let topRowIndexPath = IndexPath(row: 0, section: 0)
            
            // *
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.tableView.scrollToRow(at: topRowIndexPath, at: .top, animated: false)
                    
                }, completion: { (_) in
                    if let currencyCell = self?.tableView.cellForRow(at: topRowIndexPath) as? CurrencyTableViewCell {
                        //currencyCell.inputActivate()
                    }
                })
                
            }
            
            // **
            self?.tableView.beginUpdates()
            // Move a cell to the top of a table view:
            self?.tableView.moveRow(at: indexPath, to: topRowIndexPath)
            self?.tableView.endUpdates()
            
            // **
            
            CATransaction.commit()
            // *
        }
        
        viewModel.initFetch()
    }
    
    private func showAlert( _ message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}


























