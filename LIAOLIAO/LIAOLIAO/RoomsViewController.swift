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
    var rooms = [Room]()
    
    @IBAction func didPressCreateNewRoom(_ sender: UIButton) {
        guard let roomName = self.newRoomText.text, roomName.isEmpty == false
        else{
            return
            }
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId()
        let dataArray:[String:Any] = ["roomName": roomName]
        room.setValue(dataArray){(error,ref) in
            if (error == nil){
            self.newRoomText.text = ""
            }
            
        }
        
    }
    //跳转
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = self.rooms[indexPath.row]
        let chatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomViewController
        chatRoomView.room = selectedRoom
        self.navigationController?.pushViewController(chatRoomView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell")!
        cell.textLabel?.text = room.roomName
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
        observeRooms()
       self.roomsTable.backgroundView = UIImageView(image: UIImage(named: "back"))
        self.roomsTable.backgroundView?.alpha = 0.5

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
    
    func observeRooms(){
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) {(snapshot) in
            if let dataArray = snapshot.value as? [String: Any] {
             if let roomName = dataArray["roomName"] as? String {
                let room = Room.init(roomId: snapshot.key, roomName: roomName)
                self.rooms.append(room)
                self.roomsTable.reloadData()
                }
            }
            
        }
    }
}

