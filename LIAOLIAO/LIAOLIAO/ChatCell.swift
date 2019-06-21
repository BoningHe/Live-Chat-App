//
//  ChatCell.swift
//  LIAOLIAO
//
//  Created by 何泊宁 on 21/6/19.
//  Copyright © 2019 heboning. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var chatTextBubble: UIView!
    
    enum bubbleType {
        case incoming
        case outgoing
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBubble.layer.cornerRadius = 6
        // Initialization code
    }
    func setMessageData(message: Message){
        userNameLabel.text = message.senderName
        chatTextView.text = message.messageText
        
        
    }
    func setBubbleType(type:bubbleType){
        if(type == .incoming){
          chatStack.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            chatTextView.textColor = .black
        }else if (type == .outgoing){
        chatStack.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            chatTextView.textColor = .white
    }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
