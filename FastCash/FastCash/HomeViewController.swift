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
    

    @IBOutlet weak var logoutButtonOutlet: UIButton!
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

        //self.navigationController?.isNavigationBarHidden = true
        
        logoutButtonOutlet.layer.cornerRadius = 5.0
        
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
                let userWallet = Wallet.init(data: response, ifGenerateAccounts: false)
                
                
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
    // source: https://stackoverflow.com/questions/9239067/how-to-hide-a-navigation-bar-from-one-particular-view-controller/9239246#:~:text=UINavigationController%20has%20a%20property%20navigationBarHidden,for%20the%20whole%20nav%20controller.&text=present%20it%20before%20the%20navigation,controller%20(both%20without%20animation).
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
