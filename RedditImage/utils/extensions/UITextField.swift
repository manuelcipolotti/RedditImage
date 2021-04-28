//
//  UITextField.swift
//  Cricchetto
//
//  Created by Manuel Cipolotti Beta on 01/06/2020.
//  Copyright © 2020 Manuel Cipolotti Beta. All rights reserved.
//

import UIKit

extension UITextField {
    
    func underlinedFontMedium(color: CGColor = (UIColor.init(named: "underlinedFontMedium") ?? UIColor.clear).cgColor){

        underlined(color: color)

        let mediumFont = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.font = mediumFont

    }
    
    func lock(){

        self.layer.sublayers = nil
        self.text = nil
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        self.addSubview(imageView)
        imageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.isEnabled = false
        self.underlined(color: (UIColor.init(named: "underlined") ?? UIColor.clear).cgColor)
    }
    
    func underlined(color: CGColor = (UIColor.init(named: "underlined") ?? UIColor.clear).cgColor ){

        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }
    
    func underlinedRed(){

        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = (UIColor.init(named: "redColor") ?? UIColor.red).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true


        let mediumFont = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.font = mediumFont

    }
    
    func addPadding(spacing : CGFloat) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
        // left
        self.leftView = paddingView
        self.leftViewMode = .always
        // right
        self.rightView = paddingView
        self.rightViewMode = .always
        
    }
    
    func setTextFieldBorderColor(color : UIColor) {
        self.borderStyle = .none
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        
        self.layer.masksToBounds = false
        //        self.layer.shadowColor = UIColor.gray.cgColor
        //        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        //        self.layer.shadowOpacity = 1.0
        //        self.layer.shadowRadius = 0.0
    }
    
    func addRightImage(imageName : String,
                       arrow: Bool){
        
        self.rightViewMode = .always
        
        if arrow {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 35))

            let imageView = UIImageView(frame: CGRect(x: 0, y: 6, width: 28, height: 28))
            imageView.contentMode = UIView.ContentMode.center;
            let image = UIImage(named:imageName)
            imageView.image = image
            rightView.addSubview(imageView)

            let imageViewArrow = UIImageView(frame: CGRect(x: 40, y: 9, width: 20, height: 22))
            imageViewArrow.contentMode = UIView.ContentMode.center;
            let imageArrow = UIImage(named:"arrow")
            imageViewArrow.image = imageArrow
            rightView.addSubview(imageViewArrow)

            self.rightView = rightView
        } else {
            let rightView = UIView(frame: CGRect(x: 0, y: 5, width: 40, height: 30))

            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
            imageView.contentMode = UIView.ContentMode.center;
            let image = UIImage(named:imageName)
            imageView.image = image
            rightView.addSubview(imageView)

            self.rightView = rightView
        }
        
    }
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
