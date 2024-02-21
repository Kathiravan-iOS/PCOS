//
//  UIView.swift
//  Pcos
//
//  Created by Karthik Babu on 01/10/23.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}





class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    var startColor: UIColor = .white {
        didSet {
            updateGradient()
        }
    }

    var endColor: UIColor = .white {
        didSet {
            updateGradient()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}




extension UIViewController {
    func customizeNavigationBar(title: String?, titleColor: UIColor = .black, titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18), backButtonOffset: UIOffset = UIOffset(horizontal: -1000, vertical: 0), tintColor: UIColor = .black) {
        // Customize navigation bar title appearance
        var titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: titleFont
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        // Customize back button title position adjustment
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(backButtonOffset, for: .default)
        
        // Customize navigation bar tint color
        navigationController?.navigationBar.tintColor = tintColor
        
        // Set the navigation bar title
        title.map { self.title = $0 }
    }
}
