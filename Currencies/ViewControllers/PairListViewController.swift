//
//  ListOfPairsViewController.swift
//  Currencies
//
//  Created by Artem Lytkin on 27/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

protocol Receiver: AnyObject {
    func receive(_ data: Any)
}

class PairListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var viewModel: PairListViewModel = {
       return PairListViewModel()
    }()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PairTableViewCell.identifier,
                                                       for: indexPath) as? PairTableViewCell
            else {
                return UITableViewCell()
        }
        
        let cellModel = viewModel.getCellViewModel(at: indexPath)
        cell.configureWithCellModel(cellModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getCellHeight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let isTopCell = viewModel.isTopCell(at: indexPath)
        return isTopCell ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UINavigationController {
            viewModel.calledSegue(to: destinationVC.viewControllers.first as Any)
        }
    }
}

extension PairListViewController: Receiver {
    func receive(_ data: Any) {
        viewModel.receive(data)
    }
}
