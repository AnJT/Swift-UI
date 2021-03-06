//
//  AnnotationView.swift
//  LBSARApp
//
//  Created by ajt on 2021/12/16.
//

import UIKit
import Cosmos
import HDAugmentedReality

//1
protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    
    var delegate: AnnotationViewDelegate?
    
    override init() {
        super.init()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() -> AnnotationView{
        let customInfoWindow = Bundle.main.loadNibNamed("AnnotationView", owner: self, options: nil)?[0] as! AnnotationView
        customInfoWindow.layer.backgroundColor = UIColor(red: 62/255, green: 92/255, blue: 111/255, alpha: 0.7).cgColor
        customInfoWindow.layer.cornerRadius = 8
        customInfoWindow.ratingView.settings.fillMode = .precise

        return customInfoWindow
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
}
