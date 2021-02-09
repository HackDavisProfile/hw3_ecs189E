//
//  HomeViewController.swift
//  FastCash
//
//  Created by Trevor Carpenter on 1/18/21.
//  Copyright © 2021 Trevor Carpenter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    
    
    
    var userAccounts : [Account] = []
    var userPhone: String = ""
    

    @IBOutlet weak var AccountsTableView: UITableView!
    @IBOutlet weak var totalAmoundLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func LogoutButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        guard let navC = self.navigationController else {
            assertionFailure("couldn't find nav")
            return
        }
        navC.setViewControllers([vc], animated: true)

        
    }
    
    
    
    @IBAction func changeName(_ sender: Any) {
        
        if let text = nameField.text {
            if (text == "" ){
                Api.setName(name: userPhone) { (response, error) in
                    if (error != nil){
                        print("the error has occured to set the name of the user")
                    }
                
                    
                }

            } else {
                Api.setName(name: text) { (response, error) in
                    if (error != nil){
                        print("the error has occured to set the name of the user")
                    }
                
                    
                }

            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccountsTableView.dataSource = self

        self.navigationController?.isNavigationBarHidden = true
        
        // initiation of the user
        Api.user { (response, error) in
            if error == nil {

                // unwrapping the response
                guard let response = response else {
                    if let err = error {
                        print( err.message)
                    } else {
                       print("Unknown error")
                    }
                    return
                }
                // initiation of the user's valet
                let userWallet = Wallet.init(data: response, ifGenerateAccounts: true)
                
                
                self.userPhone = userWallet.phoneNumber
                var name = userWallet.userName ?? self.userPhone
                self.nameField.text = name
                var amount = userWallet.totalAmount
                self.totalAmoundLabel.text = String(amount)
                
                for account in userWallet.accounts {
                    self.userAccounts.append(account)
                }
                
                Storage.phoneNumberInE164 = userWallet.phoneNumber
                
                self.AccountsTableView.reloadData()
            } else {
                // probably just present the error
                print("couldn't get the user information")
                return
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return userAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "accountCell")
        
        assert(indexPath.section == 0)
        let accountName = userAccounts[indexPath.row].name
        let accountAmount = userAccounts[indexPath.row].amount
        
        cell.textLabel?.text = "\(accountName)"
        cell.detailTextLabel?.text = "\(accountAmount)"

        return cell
    }
}
