//
//  UITableViewEx.swift
//  MVVM
//
//  Created by Mahmoud Sherbeny on 26/09/2021.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell<Cell: UITableViewCell>(cell: Cell.Type)  {
        let nib = UINib(nibName: String(describing: Cell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeueCell<Cell: UITableViewCell>(indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in Cell Dequeue")
        }
        return cell
    }
}
