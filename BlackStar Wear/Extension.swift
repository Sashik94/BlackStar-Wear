//
//  Extension.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 19.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AddProfilePictureView: UIButton {

    @IBInspectable var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysTemplate)
            setupImages()
        }
    }

    func setupImages() {
        if let rightImage = rightHandImage {
            let rightImageView = UIImageView(image: rightImage)
            rightImageView.tintColor = .black

            let height = rightImage.size.height
            let width = rightImage.size.width
            let xPos = imageView!.frame.maxX
            let yPos = imageView!.frame.midY - rightImage.size.height / 2

            rightImageView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
            self.addSubview(rightImageView)
        }
    }
}

extension UIButton{

    func setImage(image: UIImage?, inFrame frame: CGRect?, for state: UIControl.State){
        self.setImage(image, for: state)

        if let frame = frame{
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
    }

}

extension UITabBar {
    
    func getFrameForTabAt(index: Int) -> CGRect? {
        if let tab = getTabViewAt(index: index) {
            return tab.frame
        }
        return nil
    }
    
    func getFrameForTabImageAt(index: Int) -> CGRect? {
        if let tab = getTabViewAt(index: index),
            let imageView = getImageViewForTabAt(index: index) {
            return tab.convert(imageView.frame, to: self)
        }
        return nil
    }
    
    func getTabViewAt(index: Int) -> UIView? {
        var tabs = self.subviews.compactMap({ $0 as? UIControl })
        tabs.sort(by: { $0.frame.origin.x < $1.frame.origin.y })
        if index < tabs.count {
            return tabs[index]
        }
        return nil
    }
    
    func getImageViewForTabAt(index: Int) -> UIView? {
        if let tab = getTabViewAt(index: index) {
            return tab.subviews.compactMap({ $0 }).first
        }
        return nil
    }
    
    func setFrameBadge() {
        
    }
    
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

//@IBDesignable class ImageView: UIImageView {
//
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//}
