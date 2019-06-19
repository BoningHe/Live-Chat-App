//
//  RoomsViewController.swift
//  LIAOLIAO
//
//  Created by 何泊宁 on 18/6/19.
//  Copyright © 2019 heboning. All rights reserved.
//

import UIKit
import Firebase

class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newRoomText: UITextField!
    
    @IBAction func didPressCreateNewRoom(_ sender: UIButton) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell")!
        cell.textLabel?.text = "Hello"
        return cell
    }
    

    @IBAction func didPressLogout(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.presentLoginScreen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsTable.delegate = self
        self.roomsTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            self.presentLoginScreen()
        }
    }
    func presentLoginScreen(){
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        self.present(formScreen, animated: true, completion: nil)
    }

    @IBOutlet weak var roomsTable: UITableView!
    
}
