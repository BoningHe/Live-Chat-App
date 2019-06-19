//
//  FormCell.swift
//  LIAOLIAO
//
//  Created by 何泊宁 on 18/6/19.
//  Copyright © 2019 heboning. All rights reserved.
//

import UIKit

class FormCell: UICollectionViewCell {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var usernameContainer: UIView!
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signIn: UIButton!
}
