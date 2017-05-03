//
//  ViewController.swift
//  Lock and Key
//
//  Created by Curtis Jackson on 4/21/17.
//  Copyright © 2017 Cybersecurity Project. All rights reserved.
//

import UIKit
import CryptoSwift

var isLoggedIn: Bool = false

class ViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var lockIcon: UIImageView!
    @IBOutlet weak var openManageButton: UIBarButtonItem!
    @IBOutlet weak var logOut: UIBarButtonItem!
    @IBOutlet var loginPopupView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
        var effect: UIVisualEffect!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var storeCredentialsButton: UIButton!

    @IBOutlet var registerPopupView: UIView!
    @IBOutlet weak var registerUserName: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    
    @IBOutlet weak var showHashedMasterCred: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        //Set background color for userName/password text fields
        userNameField.backgroundColor = UIColor(white: 1, alpha: 1)
        passwordField.backgroundColor = UIColor(white: 1, alpha: 1)

        //Set border for userName/password text fields
        userNameField.layer.borderWidth = 1.25
        userNameField.layer.cornerRadius = 5
        userNameField.layer.borderColor = UIColor.black.cgColor
        userNameField.layer.masksToBounds = true
        passwordField.layer.borderWidth = 1.25
        passwordField.layer.cornerRadius = 5
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.layer.masksToBounds = true
        
        //Set border for show hash button
        showHashedMasterCred.layer.cornerRadius = 5
            showHashedMasterCred.layer.masksToBounds = true
        
        //Text field contents settings
        userNameField.textColor = UIColor.blue
        userNameField.minimumFontSize = 64
        userNameField.clearsOnBeginEditing = true
        userNameField.placeholder = "email or username"
        
        passwordField.textColor = UIColor.blue
        passwordField.minimumFontSize = 64
        passwordField.clearsOnBeginEditing = true
        passwordField.placeholder = "password"
        
        //Disable text fields and button until login
        usernameLabel.alpha = 0
        userNameField.alpha = 0
            userNameField.isUserInteractionEnabled = false
        passwordLabel.alpha = 0
        passwordField.alpha = 0
            passwordField.isUserInteractionEnabled = false
        
        storeCredentialsButton.alpha = 0
            storeCredentialsButton.isEnabled = false
        showHashedMasterCred.alpha = 0
            showHashedMasterCred.isEnabled = false
        
        //Visual Effect/Popup settings
        effect = visualEffect.effect
        visualEffect.effect = nil
        loginPopupView.layer.cornerRadius = 5
        loginPopupView.layer.masksToBounds = true
        loginUserName.textAlignment = NSTextAlignment.center
        loginPassword.textAlignment = NSTextAlignment.center
        loginUserName.placeholder = "username"
        loginPassword.placeholder = "password"
        
        //Prepare background image animation
        background.alpha = 0
        lockIcon.alpha = 0
        
        if UserDefaults.standard.bool(forKey: "isRegistered") == false {
            // Remove previous KeychainWrapper keys if present
            KeychainWrapper.standard.removeAllKeys()
            animateInRegister()
        } else {
            animateIn()
        }
        
        print(KeychainWrapper.standard.allKeys())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(UserDefaults.standard.array(forKey: "accounts") as? [Array<UInt8>])
        print(KeychainWrapper.standard.allKeys())
        
        if isLoggedIn == true {
            
            self.navigationItem.title = "Lock and Key"
            self.openManageButton.title = "Manage"
            self.openManageButton.isEnabled = true
            self.logOut.title = "Log Out"
            self.logOut.isEnabled = true
            
            storeCredentialsButton.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            showHashedMasterCred.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            
            UIView.animate(withDuration: 0.75, animations: {
                self.background.alpha = 0
                self.lockIcon.alpha = 0
                self.usernameLabel.alpha = 1
                self.userNameField.alpha = 1
                    self.userNameField.isUserInteractionEnabled = true
                self.passwordLabel.alpha = 1
                self.passwordField.alpha = 1
                    self.passwordField.isUserInteractionEnabled = true
                self.storeCredentialsButton.transform = CGAffineTransform.identity
                self.storeCredentialsButton.alpha = 1
                    self.storeCredentialsButton.isEnabled = true
                self.showHashedMasterCred.transform = CGAffineTransform.identity
                self.showHashedMasterCred.alpha = 1
                    self.showHashedMasterCred.isEnabled = true
                
            })
            
        } else {
            
            //Hide page fields
            background.alpha = 0
            lockIcon.alpha = 0
            usernameLabel.alpha = 0
            userNameField.alpha = 0
            passwordLabel.alpha = 0
            passwordField.alpha = 0
            storeCredentialsButton.alpha = 0
            showHashedMasterCred.alpha = 0
            self.logOut.title = ""
            self.openManageButton.title = ""
            self.navigationItem.title = ""
            self.logOut.isEnabled = false
            self.openManageButton.isEnabled = false
            self.storeCredentialsButton.isEnabled = false
            self.showHashedMasterCred.isEnabled = false
            
        }
        
    }
    
    func animateIn() {
        self.view.addSubview(loginPopupView)
        loginPopupView.center = self.view.center
        
        loginPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        loginPopupView.alpha = 0
        
        UIView.animate(withDuration: 0.75) {
            self.visualEffect.effect = self.effect
            self.loginPopupView.alpha = 1
            self.loginPopupView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateInRegister() {
        self.view.addSubview(registerPopupView)
        registerPopupView.center = self.view.center
        
        registerPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        registerPopupView.alpha = 0
        
        UIView.animate(withDuration: 0.75) {
            self.visualEffect.effect = self.effect
            self.registerPopupView.alpha = 1
            self.registerPopupView.transform = CGAffineTransform.identity
            
        }
        
    }
    
    func animateOut() {
        storeCredentialsButton.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        showHashedMasterCred.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
    
        UIView.animate(withDuration: 0.3, animations: {
            self.loginPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.loginPopupView.alpha = 0
            
            self.visualEffect.effect = nil
            
        }) {(success: Bool) in
            self.loginPopupView.removeFromSuperview()
            self.visualEffect.removeFromSuperview()
            
            UIView.animate(withDuration: 0.75, animations: {
                
                self.navigationItem.title = "Lock and Key"
                self.openManageButton.title = "Manage"
                    self.openManageButton.isEnabled = true
                self.logOut.title = "Logout"
                    self.logOut.isEnabled = true
                
                self.background.alpha = 0
                self.lockIcon.alpha = 0
                self.usernameLabel.alpha = 1
                self.userNameField.alpha = 1
                    self.userNameField.isUserInteractionEnabled = true
                self.passwordLabel.alpha = 1
                self.passwordField.alpha = 1
                    self.passwordField.isUserInteractionEnabled = true
                self.storeCredentialsButton.transform = CGAffineTransform.identity
                self.storeCredentialsButton.alpha = 1
                    self.storeCredentialsButton.isEnabled = true
                self.showHashedMasterCred.transform = CGAffineTransform.identity
                self.showHashedMasterCred.alpha = 1
                    self.showHashedMasterCred.isEnabled = true
                
            })
   
        }
        
    }
    
    func animateOutRegister() {
        storeCredentialsButton.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        showHashedMasterCred.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.registerPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.registerPopupView.alpha = 0
            
            self.visualEffect.effect = nil
            
        }) {(success: Bool) in
            self.registerPopupView.removeFromSuperview()
            self.visualEffect.removeFromSuperview()
            
            UIView.animate(withDuration: 0.75, animations: {
                
                self.navigationItem.title = "Lock and Key"
                self.openManageButton.title = "Manage"
                self.openManageButton.isEnabled = true
                self.logOut.title = "Log Out"
                self.logOut.isEnabled = true
                self.background.alpha = 0
                self.lockIcon.alpha = 0
                self.usernameLabel.alpha = 1
                self.userNameField.alpha = 1
                self.userNameField.isUserInteractionEnabled = true
                self.passwordLabel.alpha = 1
                self.passwordField.alpha = 1
                self.passwordField.isUserInteractionEnabled = true
                self.storeCredentialsButton.transform = CGAffineTransform.identity
                self.storeCredentialsButton.alpha = 1
                self.storeCredentialsButton.isEnabled = true
                self.showHashedMasterCred.transform = CGAffineTransform.identity
                self.showHashedMasterCred.alpha = 1
                self.showHashedMasterCred.isEnabled = true
                
            })
            
        }
        
    }

    @IBAction func confirmLogin(_ sender: UIButton) {
        
        if (loginUserName.text != "") && (loginPassword.text != "") {

            let hash = Array(loginUserName.text!.utf8).sha512().toBase64()
                
            if UserDefaults.standard.string(forKey: "username") == hash! &&
                KeychainWrapper.standard.string(forKey: loginUserName.text!) == loginPassword.text! {
                    animateOut()
                    isLoggedIn = true
            } else {
                let error = UIAlertController(title: "Error", message: "Incorrect login.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                error.addAction(myAction)
                present(error, animated: true, completion: nil)
                    
            }
        } else {
            let fieldsEmpty = UIAlertController(title: "Invalid Input", message: "One or more fields are empty.", preferredStyle: .alert)
            let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                fieldsEmpty.addAction(myAction)
                present(fieldsEmpty, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func confirmRegister(_ sender: Any) {
        
        if (registerUserName.text != "") && (registerPassword.text != "") {
            UserDefaults.standard.set(true, forKey: "isRegistered")
            
            let hash = Array(registerUserName.text!.utf8).sha512().toBase64()
            
            // Save username hash to userdefaults
            UserDefaults.standard.set(hash!, forKey: "username")
                
            let savePassword: Bool = KeychainWrapper.standard.set(registerPassword.text!, forKey: registerUserName.text!)
            
            // Generate random 32-byte alphanumeric key
            let key = randomString(length: 32)
            KeychainWrapper.standard.set(key, forKey: "key")
            
            // Generate random 32-byte initialization vector
            let iv = randomString(length: 16)
            KeychainWrapper.standard.set(iv, forKey: "iv")
            
            // Create empty array of user accounts
            UserDefaults.standard.set([[UInt8]](), forKey: "accounts")
        
            animateOutRegister()
            isLoggedIn = true
            
        } else {
            let fieldsEmpty = UIAlertController(title: "Invalid Input", message: "One or more fields are empty.", preferredStyle: .alert)
            let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            fieldsEmpty.addAction(myAction)
            present(fieldsEmpty, animated: true, completion: nil)
            
        }
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func hexStringtoAscii(_ hexString : String) -> String {
        
        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = hexString as NSString
        let matches = regex.matches(in: hexString, options: [], range: NSMakeRange(0, nsString.length))
        let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.rangeAt(2)), radix: 16)!)!)
        }
        return String(characters)
    }
    
    @IBAction func toManagePage(_ sender: UIBarButtonItem) {
        self.background.alpha = 1
        self.lockIcon.alpha = 1
        self.usernameLabel.alpha = 0
        self.userNameField.alpha = 0
        self.passwordLabel.alpha = 0
        self.passwordField.alpha = 0
        self.performSegue(withIdentifier: "toManagePage", sender: nil)
        
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        isLoggedIn = false
        
    }
    
    @IBAction func showHashedMasterCred(_ sender: UIButton) {
        //Prints hashed master credentials
        let hashedCredentialsPopUp = UIAlertController(title: "Master Key Hash:", message: "\("Hashed Username: " + (UserDefaults.standard.string(forKey: "username"))!)\n\nHashed Password: <put password hash here>", preferredStyle: .alert)
        let seen = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            hashedCredentialsPopUp.addAction(seen)
            present(hashedCredentialsPopUp, animated: true, completion: nil)
        
    }
    
    @IBAction func storeCredentials(_ sender: UIButton) {
        //send stored password to UserDefaults
        
        if (userNameField.text != "") && (passwordField.text != "") {
            
            if KeychainWrapper.standard.allKeys().contains(userNameField.text!) {
                let exists = UIAlertController(title: "Username already exists!", message: "Please choose another username.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                exists.addAction(myAction)
                present(exists, animated: true, completion: nil)
            } else {
                do {
                    
                    let aes = try AES(key: KeychainWrapper.standard.string(forKey: "key")!, iv: KeychainWrapper.standard.string(forKey: "iv")!)
                    var array = UserDefaults.standard.array(forKey: "accounts") as! [Array<UInt8>]
                    let username = try aes.encrypt(Array(userNameField.text!.utf8))
                    array.append(username)
                    
                    UserDefaults.standard.set(array, forKey: "accounts")
                    
                    KeychainWrapper.standard.set(passwordField.text!, forKey: userNameField.text!)
                } catch {}
            }
            
            let passwordStored = UIAlertController(title: "Password Stored", message: "Navigate to the manage page to view your stored passwords.", preferredStyle: .alert)
            let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action) in
                //do stuff here when OK button is pressed if needed
                
            })
            passwordStored.addAction(myAction)
            present(passwordStored, animated: true, completion: {
                self.passwordField.text = ""
                self.userNameField.text = ""
                
            })
            
        } else {
            let fieldsEmpty = UIAlertController(title: "Invalid Input", message: "One or more fields are empty.", preferredStyle: .alert)
            let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                fieldsEmpty.addAction(myAction)
                present(fieldsEmpty, animated: true, completion: nil)
        }
        print(UserDefaults.standard.array(forKey: "accounts") as? [Array<UInt8>])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
