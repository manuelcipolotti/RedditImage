//
//  UIView.swift
//  Cricchetto
//
//  Created by Manuel Cipolotti Beta on 25/05/2020.
//  Copyright © 2020 Manuel Cipolotti Beta. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
      get {
        return layer.borderWidth
      }
      set(newValue) {
        layer.borderWidth = newValue
      }
    }

    @IBInspectable var borderColor: UIColor? {
      get {
        if let color = layer.borderColor {
          return UIColor(cgColor: color)
        }
        return nil
      }
      set(newValue) {
          layer.borderColor = newValue?.cgColor
      }
      
    }

    @IBInspectable var cornerRadius: CGFloat {
      get {
        return layer.cornerRadius
      }
      set(newValue) {
        layer.cornerRadius = newValue
      }
    }


}
