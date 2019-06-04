//
//  ListOfPairsViewController.swift
//  Currencies
//
//  Created by Artem Lytkin on 27/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

protocol Receiver: AnyObject {
    func receive(_ pairs: [Pair])
}

class PairListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Private Properties
    
    private var viewModel: PairListViewModel = {
       return PairListViewModel()
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !viewModel.isTopCell(at: indexPath) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath)
            return cell
        }
        
        guard let cellModel = viewModel.getCellViewModel(at: indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: PairTableViewCell.identifier,
                                                       for: indexPath) as? PairTableViewCell
            else {
                return UITableViewCell()
        }
        
        cell.configureWithCellModel(cellModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.removeAction(at: indexPath)
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return viewModel.isTopCell(at: indexPath) ? .none : .delete
    }
    
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        viewModel.beginEditingAction()
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        viewModel.endEditingAction()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getCellHeight(at: indexPath)
    }
     
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let isTopCell = viewModel.isTopCell(at: indexPath)
        return isTopCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UINavigationController {
            viewModel.calledSegue(to: destinationVC.viewControllers.first as Any)
        }
    }
    
    // MARK: - Private
    
    private func initViewModel() {
        
        viewModel.backToEmptyScreen = { [weak self] in
            DispatchQueue.main.async {
                guard let tabbarVC = self?.parent as? UITabBarController else { return }
                tabbarVC.selectedIndex = 0
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.tableDeleteRowsClosure = { [weak self] indexPaths in
            DispatchQueue.main.async {
                self?.tableView.deleteRows(at: indexPaths, with: .left)
            }
        }
        
        viewModel.showAlertClosure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
        
        NotificationCenter.default.addObserver(viewModel,
                                               selector: #selector(viewModel.viewDidDisappear),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        viewModel.startEngine()
    }
}

// MARK: - Receiver

extension PairListViewController: Receiver {
    func receive(_ pairs: [Pair]) {
        viewModel.receive(pairs)
    }
}
