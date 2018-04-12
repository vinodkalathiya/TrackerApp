//
//  LoginViewContoller.swift
//  GPSTracker
//
//  Created by Sensu Soft on 25/12/17.
//  Copyright © 2017 Sensu Soft. All rights reserved.
//

import UIKit

class LoginViewContoller: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        doSetupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func doSetupUI() {
        
        txtPassword.useUnderline(color: APP_BLUE_COLOR)
        txtUsername.useUnderline(color: APP_BLUE_COLOR)
    }
    
    func validationMethod() -> Bool {
        
        if (txtUsername.text?.isEmpty)! {
            displayAlertWithMessage("Please Enter Username.")
            return false
        }
        
        if (txtPassword.text?.isEmpty)! {
            displayAlertWithMessage("Please Enter Password.")
            return false
        }
        
        return true
    }
    
    func apiCallingHandling() {
        var param = [String:AnyObject]()
        param["username"] = txtUsername.text as AnyObject
        param["password"] = txtPassword.text as AnyObject
        
        print(param)
        ServiceManager.apiLoginWithParameters(param) { (isSuccess) in
            if(isSuccess){
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if validationMethod() {
            apiCallingHandling()
        }
        
        
    }
    
    
}
