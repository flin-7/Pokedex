//
//  UITableView+Ext.swift
//  Pokedex
//
//  Created by Felix Lin on 2/12/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
