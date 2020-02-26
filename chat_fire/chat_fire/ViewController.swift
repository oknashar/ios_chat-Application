//
//  ViewController.swift
//  chat_fire
//
//  Created by OKNASHAR on 2/26/20.
//  Copyright © 2020 OKNASHAR. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "formcell", for: indexPath) as! FormCell
        if(indexPath.row == 0){
            cell.userNameContainer.isHidden = true
            cell.actionButton.setTitle("Login", for: .normal)
            cell.slideButton.setTitle("Sign Up 👉", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignIn(_:)), for: .touchUpInside)
        } else if(indexPath.row == 1){
            cell.userNameContainer.isHidden = false
            cell.actionButton.setTitle("Sign Up", for: .normal)
            cell.slideButton.setTitle(" Sign In", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignUpCell(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)
        }
        
        return cell
        
    }
    @objc func didPressSignIn(_ sender:UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCell
        guard let emailAddress = cell.emailTextField.text,let password = cell.passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            if (error == nil){
                print(result?.user.uid)
            }else{
                self.displayError(errorText: "Wrong Email or password")
            }
        }
    }
    @objc func didPressSignUp(_ sender:UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCell
        guard let emailAddress = cell.emailTextField.text,let password = cell.passwordTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if(error == nil){
                guard let userId = result?.user.uid,let userName = cell.userNameTextField.text else{
                    return
                }
                let reference = Database.database().reference()
                let user = reference.child("users").child(userId)
                let dataArray:[String:Any] = ["username":userName]
                user.setValue(dataArray)
            }else{
                self.displayError(errorText: "Wrong Email or password")
            }
        }
    }
        
        @objc func slideToSignInCell(_ sender:UIButton){
            let indexPath = IndexPath(row: 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        }
        @objc func slideToSignUpCell(_ sender:UIButton){
            let indexPath = IndexPath(row: 0, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return self.collectionView.frame.size
        }
    func displayError(errorText:String){
        let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}

