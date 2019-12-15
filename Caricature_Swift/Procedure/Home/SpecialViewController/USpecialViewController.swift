//
//  USpecialViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/16.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class USpecialViewController: UBaseViewController {
    
    private var page: Int = 1
    private var argCon: Int = 0
    
    convenience init(argCon: Int = 0) {
        self.init()
        self.argCon = argCon
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
