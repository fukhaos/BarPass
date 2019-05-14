//
//  UIView.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 29/01/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    
    func setBorder(radius:CGFloat, color:UIColor = UIColor.clear, width: Int = 1) {
        let roundView:UIView = self
        roundView.layer.cornerRadius = CGFloat(radius)
        roundView.layer.borderWidth = CGFloat(width)
        roundView.layer.borderColor = color.cgColor
        roundView.clipsToBounds = true
    }
    
    // MARK: Shadows
    func dropShadow(opacity: Float, radius: CGFloat, offSetWidth: CGFloat = 0, offSetHeight: CGFloat = 0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: offSetWidth, height: offSetHeight)
    }
    
    func removeShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize.zero
    }
}
