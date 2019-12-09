//
//  UHomeViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/21.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UHomeViewController: UPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                                           target: self,
                                                                           action: #selector(selectAction))
    }
    
    @objc private func selectAction() {
        navigationController?.pushViewController(USearchViewController(), animated: true)
    }

}
