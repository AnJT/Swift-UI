//
//  RoundedBtn.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import UIKit

class RoundedBtn: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 57, green: 88, blue: 108)
    }
}
