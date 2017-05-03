//
//  TableViewCell.swift
//  Lock and Key
//
//  Created by Matt Argao on 4/26/17.
//  Copyright © 2017 Cybersecurity Project. All rights reserved.
//

import UIKit
import CryptoSwift

class TableViewCell: UITableViewCell {

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        usernameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        passwordLabel.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    @IBAction func copyToClipboard(_ sender: Any) {
        let copy = KeychainWrapper.standard.string(forKey: usernameLabel.text!)!
        
        print("Copied: \(copy)")
        
        
        let passwordCopied = UIAlertController(title: "Password Copied", message: "\"\(copy)\" copied to clipboard.", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {
            (action) in
            UIPasteboard.general.string = copy
            
        })
        passwordCopied.addAction(myAction)
         UIApplication.shared.keyWindow?.rootViewController?.present(passwordCopied, animated: true, completion: nil)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
