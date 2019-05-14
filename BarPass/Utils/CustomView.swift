//
//  CustomView.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 20/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit

class CustomView: UIView, ProgrammableUIProtocol {
    
    @IBInspectable open var borderWith : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWith
        }
    }
    
    @IBInspectable open var borderColor : UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable open var cornerRadius : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            if !self.isShadowEnabled {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable open var isShadowEnabled : Bool = false {
        didSet {
            self.checkShadow()
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        initViews()
        setupConstraints()
    }
    
    override init(frame: CGRect = CGRect(x: 0, y: 0, width: 104, height: 56)) {
        super.init(frame: frame)
        initViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
        setupConstraints()
    }
    
    func initViews() {
        self.checkShadow()
    }
    
    func setupConstraints() {
        
    }
    
    private func checkShadow(){
        if self.isShadowEnabled {
            self.dropShadow(opacity: 0.1, radius: 2, offSetWidth: 0, offSetHeight: 2)
        } else {
            self.removeShadow()
        }
    }
    
}
