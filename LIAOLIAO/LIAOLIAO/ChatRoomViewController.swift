//
//  ChatRoomViewController.swift
//  LIAOLIAO
//
//  Created by 何泊宁 on 19/6/19.
//  Copyright © 2019 heboning. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatMessages[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        cell.setMessageData(message: message)
        if (message.userId == Auth.auth().currentUser?.uid){
            cell.setBubbleType(type: .outgoing)
            
        }else{
            cell.setBubbleType(type: .incoming)
        }
     
        return cell
    }
    
    
    var room:Room?
    @IBOutlet weak var chatText: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    var chatMessages = [Message]()
    
    func observeMessage(){
        guard let roomId = self.room?.roomId else {
            return
        }
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").child(roomId).child("messages").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String: Any] {
                guard let senderName = dataArray["senderName"] as? String, let messageText = dataArray["text"] as? String, let userId = dataArray["senderId"] as? String else{
                    return
                }
                let message = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: messageText, userId: userId)
                self.chatMessages.append(message)
                self.chatTableView.reloadData()
            }
        }
    }
    @IBAction func didPressSendButton(_ sender: UIButton) {
        guard let chatTextContent = self.chatText.text, chatTextContent.isEmpty == false else {
            return
        }
        sendMessage(text: chatTextContent) { (isSuccess) in
            if(isSuccess)
            {
               self.chatText.text = ""
            }
        }
 
    }
    func getUsernameWithId(id:String,completion: @escaping (_ userName:String?)-> ()){
        let databaseRef = Database.database().reference()
        let user = databaseRef.child("users").child(id)
        user.child("username").observeSingleEvent(of: .value) {( snapshot
            ) in if let userName = snapshot.value as? String
            {
                completion(userName)
            } else{
                completion(nil)
            }
            
        }
    }
    func sendMessage(text:String, completion: @escaping (_ isSuccess:Bool) -> ()){
        guard  let userId = Auth.auth().currentUser?.uid  else {
            return
        }
        
        let databaseRef = Database.database().reference()
        getUsernameWithId(id: userId) { (userName) in
           
            if let userName = userName
            {
                if let roomId = self.room?.roomId , let userId = Auth.auth().currentUser?.uid{
                    let dataArray: [String:Any] = ["senderName": userName, "text": text, "senderId": userId]
                    let room =
                        databaseRef.child("rooms").child(roomId)
                    room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: {(error, ref) in
                        if(error == nil){
                            completion(true)
                            // self.chatText.text = ""
                            // print("room added to database successfully")
                        }else{
                            completion(false)
                        }
                    })
                }
            }
        }
       
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            chatText.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsernameWithId(id: Auth.auth().currentUser!.uid) { (userName) in
            print(userName)
        }
        chatTableView.dataSource = self
        chatTableView.delegate = self
        observeMessage()
        chatTableView.separatorStyle = .none
        title = room?.roomName
        self.chatTableView.backgroundView = UIImageView(image: UIImage(named: "back"))
        self.chatTableView.backgroundView?.alpha = 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
