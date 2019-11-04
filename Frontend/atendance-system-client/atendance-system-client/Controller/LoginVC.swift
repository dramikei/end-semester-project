//
//  ViewController.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 25/09/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit
import Alamofire
class LoginVC: UIViewController {

    
    @IBOutlet weak var enrolmentField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        if enrolmentField.text != "" && passwordField.text != "" {
            let enrolment = enrolmentField.text!
            let password = passwordField.text!
            let data = [
                "enrolment": enrolment,
                "password": password
            ]
            AF.request(loginURL, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil).responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let login = try decoder.decode(Login.self, from: data)
                    if login.result == "True" {
                        // Transition to tab bar
                        print("Transitioning")
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "isUserLoggedIn")
                        defaults.set(enrolment, forKey: "Enrolment")
                        defaults.synchronize()
                        let mainvc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "mainVC")
                        mainvc.modalPresentationStyle = .fullScreen
                        self.dismiss(animated: false, completion: nil)
                        self.present(mainvc, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Wrong Credentials", message:
                        "The enrolment number or the password provided is incorrect.\nPlease try again.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        //Dismissing present VC so as to avoid stacking ViewControllers in an event of multiple login and logouts
                        self.present(alertController, animated: true, completion: nil)
                    }
                } catch let error {
                    print(error)
                }
            }
        }
        
    }
    


}

