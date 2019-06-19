//
//  ChatRoomViewController.swift
//  LIAOLIAO
//
//  Created by 何泊宁 on 19/6/19.
//  Copyright © 2019 heboning. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    var room:Room?
    @IBOutlet weak var chatText: UITextField!
    
    @IBAction func didPressSendButton(_ sender: UIButton) {
        guard let chatTextContent = self.chatText.text, chatTextContent.isEmpty == false else {
            return
        }
        sendMessage(text: chatTextContent) { (isSuccess) in
            if(isSuccess)
            {
                print("message sent")
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
                if let roomId = self.room?.roomId {
                    let dataArray: [String:Any] = ["senderName": userName, "text": text]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsernameWithId(id: Auth.auth().currentUser!.uid) { (userName) in
            print(userName)
        }
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
