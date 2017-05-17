//
//  UIImagePropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

struct UIImageViewPropertySet : DynamicStylePropertySet {
    var propertySet: Dictionary<String, Any> = UIImageView().retriveDynamicPropertySet()

    var image:UIImage?
    var customUIImageViewStyleBlock:((UIImageView)->())?
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariant(of: "Image"):
            image = value as? UIImage
        default :
            return
        }
    }
}

extension StyleClass {
    var UIImageView:UIImageViewPropertySet { get { return self.retrieve(propertySet: UIImageViewPropertySet.self) } set { self.register(propertySet: newValue) } }
}

#if (TARGET_INTERFACE_BUILDER && !DISABLE_DESIGNABLES) || !TARGET_INTERFACE_BUILDER
@IBDesignable class StyleableUIImageView : UIImageView, Styleable {
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let imageView = target as? UIImageView {
                imageView.image =? style.UIImageView.image
                if let customStyleBlock = style.UIImageView.customUIImageViewStyleBlock { customStyleBlock(imageView) }
            }
            }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
}
#endif
