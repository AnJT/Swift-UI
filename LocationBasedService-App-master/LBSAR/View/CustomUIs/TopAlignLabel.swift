//
//  TopAlignLabel.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import UIKit

class TopAlignLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    class TopAlignLabel: UILabel {
        
        override func drawText(in rect:CGRect) {
            guard let labelText = text else {  return super.drawText(in: rect) }
            
            let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font])
            var newRect = rect
            newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
            
            if numberOfLines != 0 {
                newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
            }
            
            super.drawText(in: newRect)
        }
    }

}
