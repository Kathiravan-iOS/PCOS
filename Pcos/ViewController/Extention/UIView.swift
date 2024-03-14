//
//  UIView.swift
//  Pcos
//
//  Created by Karthik Babu on 01/10/23.
//

import Foundation
import UIKit
import NVActivityIndicatorView


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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        precondition(red >= 0 && red <= 255, "Invalid red component")
        precondition(green >= 0 && green <= 255, "Invalid green component")
        precondition(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

extension UIView {
    private static var loaderView: UIView?
    
    func startLoader() {
        if UIView.loaderView != nil {
            return
        }
        let loaderView = UIView(frame: self.bounds)
        loaderView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(loaderView)
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: .ballClipRotateMultiple, color: UIColor(hex: "#FFACD3"))
        loader.center = loaderView.center
        loaderView.addSubview(loader)
        loader.startAnimating()
        UIView.loaderView = loaderView
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            UIView.loaderView?.removeFromSuperview()
            UIView.loaderView = nil
        }
    }
}

