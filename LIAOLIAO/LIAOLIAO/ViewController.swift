//
//  ViewController.swift
//  LIAOLIAO
//
//  Created by 何泊宁 on 18/6/19.
//  Copyright © 2019 heboning. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! FormCell
        if (indexPath.row == 0) { //sign in cell
            cell.usernameContainer.isHidden = true
            cell.signUp.setTitle("Login", for: .normal)
            cell.signIn.setTitle("Sign Up ➡️", for: .normal)
            cell.signIn.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)
            cell.signUp.addTarget(self, action: #selector(didPressSignIn(_:)), for: .touchUpInside)
        }
        else if (indexPath.row == 1) { //sign up cell
            cell.usernameContainer.isHidden = false
            cell.signUp.setTitle("Sign Up", for: .normal)
            cell.signIn.setTitle("⬅️ Sign In", for: .normal)
            cell.signIn.addTarget(self, action: #selector(slideToSignUpCell(_:)), for: .touchUpInside)
            cell.signUp.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)
        }
      
        return cell
    }
    @objc func didPressSignIn(_ sender: UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCell
        guard let emailAddress = cell.emailAddress.text, let password = cell.password.text else {
            return
        }
        if (emailAddress.isEmpty == true || password.isEmpty == true){
            self.displayError(errorText: "Please fill empty fields")
        } else{
                Auth.auth().signIn(withEmail: emailAddress, password: password) {(result, error) in
                    if (error == nil) {
                        self.dismiss(animated: true, completion: nil)
                        print(result?.user)
                    }
                    else{
                        self.displayError(errorText: "Wrong username or password")
                    }
                }
        }
    }
    func displayError (errorText: String){
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let dismissButton = UIAlertAction.init (title: "Cancel", style: .default, handler: nil)
        alert.addAction(dismissButton)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func didPressSignUp(_ sender:UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCell
        guard let emailAddress = cell.emailAddress.text, let password = cell.password.text else {
            return
        }
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if (error == nil){
                guard let userId = result?.user.uid, let userName = cell.userName.text else{
                        return
            }
              self.dismiss(animated: true, completion: nil)
              let reference = Database.database().reference()
              let user = reference.child("users").child(userId)
              let dataArray:[String: Any] = ["username" : userName]
              user.setValue(dataArray)
            }
            
        }
    }
    @objc func slideToSignInCell(_ sender: UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        
    }
    @objc func slideToSignUpCell(_ sender: UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let reference = Database.database().reference()
        let rooms = reference.child("roomsTest")
        rooms.setValue("Hello World!")
        // Do any additional setup after loading the view.
    }


}

