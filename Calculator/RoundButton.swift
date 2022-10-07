//
//  RoundButton.swift
//  Calculator
//
//  Created by Mingyuan Xie on 9/20/22.
//

import UIKit

class RoundButton: UIButton {

    @IBInspectable var roundButton:Bool = false {
           didSet {
               if roundButton {
                   layer.cornerRadius = frame.height / 3
               }
           }
       }
       
       override func prepareForInterfaceBuilder() {
           if roundButton {
               layer.cornerRadius = frame.height/3
           }
       }

}
