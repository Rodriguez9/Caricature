//
//  UUpdateListViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/16.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UUpdateListViewController: UBaseViewController {

     private var argCon: Int = 0
     private var argName: String?
     private var argValue: Int = 0
     private var page: Int = 1
    
    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0){
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
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
