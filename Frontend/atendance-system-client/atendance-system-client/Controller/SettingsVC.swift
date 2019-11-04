//
//  SettingsVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 01/11/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isUserLoggedIn")
        defaults.synchronize()
        let mainvc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "LoginVC")
        mainvc.modalPresentationStyle = .fullScreen
        self.dismiss(animated: false, completion: nil)
        self.present(mainvc, animated: true, completion: nil)
    }
    
    

}
