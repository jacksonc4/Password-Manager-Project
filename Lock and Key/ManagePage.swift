//
//  ManagePage.swift
//  Lock and Key
//
//  Created by Curtis Jackson on 4/22/17.
//  Copyright © 2017 Cybersecurity Project. All rights reserved.
//

import UIKit
import CryptoSwift

class ManagePage: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var lockIcon: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var deleteAtIndex: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))

        tableView.delegate = self
        tableView.dataSource = self
        background.alpha = 0
        lockIcon.alpha = 0
        tableView.alpha = 0
        infoLabel.alpha = 0
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        animateTableView()
        
        self.navigationItem.title = "Passwords"
        
    }
    
    func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
        
    }
    
    func animateTableView() {
        tableView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.75) {
            self.background.alpha = 1
            self.lockIcon.alpha = 1
            self.tableView.alpha = 1
            self.infoLabel.alpha = 0.65
            self.tableView.transform = CGAffineTransform.identity
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.array(forKey: "accounts")!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view?.frame.height)! / 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        if UserDefaults.standard.array(forKey: "accounts")!.count > 0{
            do {
                let aes = try AES(key: KeychainWrapper.standard.string(forKey: "key")!, iv: KeychainWrapper.standard.string(forKey: "iv")!)
                
                let array = UserDefaults.standard.array(forKey: "accounts") as! [Array<UInt8>]
                
                let username = array[indexPath.row]
                
                let output = try aes.decrypt(username).toHexString()
                
                cell.usernameLabel.text = hexStringtoAscii(output)
                cell.passwordLabel.text = KeychainWrapper.standard.string(forKey: hexStringtoAscii(output))!
            } catch { }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected credentials at cell \(indexPath.row)")
        
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        self.performSegue(withIdentifier: "editItemSegue", sender: dataobject)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        
        if editingStyle == .delete {
            var array = UserDefaults.standard.array(forKey: "accounts") as! [Array<UInt8>]
            
            let deleteAlert = UIAlertController(title: "Delete Entry", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                do {
                    let aes = try AES(key: KeychainWrapper.standard.string(forKey: "key")!, iv: KeychainWrapper.standard.string(forKey: "iv")!)
                    let decrypt = try aes.decrypt(array[indexPath.row])
                    var outputString = ""
                    for i in 0..<decrypt.count {
                        outputString += String(Character(UnicodeScalar(decrypt[i])))
                    }
                    array.remove(at: indexPath.row)
                    UserDefaults.standard.set(array, forKey: "accounts")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    KeychainWrapper.standard.removeObject(forKey: outputString)
                } catch {}
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                // Do nothing
            }))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(deleteAlert, animated: true, completion: nil)
            
        }
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
    
}
