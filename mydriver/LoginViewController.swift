//
//  LoginViewController.swift
//  mydriver
//
//  Created by Osama Soliman on 4/6/19.
//  Copyright © 2019 Osama Soliman. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var driverLabel: UILabel!
    
    @IBOutlet weak var riderLabel: UILabel!
    
    @IBOutlet weak var signupbutton: UIButton!
    
    @IBOutlet weak var signinbutton: UIButton!
    
    var signupstate = true
    
    func displayallert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextfield.delegate = self
        self.passwordTextfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
  
    
    @IBAction func Signup(_ sender: Any) {
        
        if userNameTextfield.text == "" || passwordTextfield.text == "" {
            displayallert(title: "missing fields", message: "username and password are required")
        }else {
            let user = PFUser()
            user.username = userNameTextfield.text
            user.password = passwordTextfield.text
                if signupstate == true{
                    user["isdriver"] = `switch`.isOn
                    user.signUpInBackground { (succeed, error) in
                        if let error = error{
                            if let errorString = error as? String{
                                self.displayallert(title: "error signing up ", message: errorString)
                            }
                        }else{
                            if  self.`switch`.isOn == true {
                                self.performSegue(withIdentifier: "loginDriver", sender: self)
                            }else
                            {
                                self.performSegue(withIdentifier: "loginRider", sender: self)
                            }
                        }
                            
                    }
                }else {
                    PFUser.logInWithUsername(inBackground: user.username!, password: user.password!) { (user,error) in
                        if let user = user{
                            if  user["isdriver"]! as! Bool == true {
                                self.performSegue(withIdentifier: "loginDriver", sender: self)
                            }else
                            {
                                self.performSegue(withIdentifier: "loginRider", sender: self)
                            }
                        }else{
                            self.displayallert(title: "no such user", message: "the username or password wrong")
                        }
                    }
                    
            }
          
        }
        
    }
    
    @IBAction func signin(_ sender: Any) {
        if signupstate == true{
            signupbutton.setTitle("Log In", for: UIControl.State.normal)
            signinbutton.setTitle("Sign Up", for: UIControl.State.normal)
            signupstate = false
            riderLabel.alpha = 0
            driverLabel.alpha = 0
            `switch`.alpha = 0
        }else{
            signupbutton.setTitle("Sign Up", for: UIControl.State.normal)
            signinbutton.setTitle("Log In", for: UIControl.State.normal)
            signupstate = true
            riderLabel.alpha = 1
            driverLabel.alpha = 1
            `switch`.alpha = 1
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        if(PFUser.current() != nil){
            if  PFUser.current()!["isdriver"]! as! Bool == true {
                self.performSegue(withIdentifier: "loginDriver", sender: self)
            }else
            {
                self.performSegue(withIdentifier: "loginRider", sender: self)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}
