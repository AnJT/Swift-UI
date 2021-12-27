//
//  HomeCell.swift
//  LBSARApp
//
//  Created by ajt on 2021/12/16.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    // 计算属性
    var homeItem: HomeItem? {
        didSet {
            configureCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        if let aHomeItem = homeItem {
            lblTitle.text = aHomeItem.itemTitle
            imgIcon.image = UIImage (named: aHomeItem.key)
        }
    }
}
