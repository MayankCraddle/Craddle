//  NSLayoutHelper.swift
//  Layout Helper
//
//  Created by Wabbiters on 4/15/19.
//  Copyright © 2019 Wabbiters. All rights reserved.
import UIKit

//case iPhoneXR_11
//case iPhone12Mini
//case iPhone11Pro
//case iPhoneX_XS
//case iPhone12_12Pro
//case iPhoneXSMax_ProMax
//case iPhone12ProMax
//case unknow

@IBDesignable class NSLayoutHelper : NSLayoutConstraint {

    @IBInspectable var iPhoneXR_11: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhoneXR_11,value:iPhoneXR_11) }
    }

    @IBInspectable var iPhone11Pro: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhone11Pro,value:iPhone11Pro) }
    }
    
    @IBInspectable var iPhone12Mini: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhone12Mini,value:iPhone12Mini) }
    }
    
    @IBInspectable var iPhone12_12Pro: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhone12_12Pro,value:iPhone12_12Pro) }
    }
    
    @IBInspectable var iPhone12ProMax: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhone12ProMax,value:iPhone12ProMax) }
    }
    
    @IBInspectable var iPhoneX_XS: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhoneX_XS,value:iPhoneX_XS) }
    }
    
    @IBInspectable var iPhoneXSMax_ProMax: CGFloat = 0.0 {
        didSet { deviceConstant(.iPhoneXSMax_ProMax,value:iPhoneXSMax_ProMax) }
    }

    // Helpers
    open func deviceConstant(_ device:UIDevice.DeviceType,value:CGFloat) {
        if UIDevice.deviceType == device {
            constant = value
        }
    }
}








/*
@IBDesignable class NSLayoutHelper : NSLayoutConstraint {

    @IBInspectable var iPhoneSE: CGFloat = 0.0 {
        didSet { deviceConstant(.i4Inch,value:iPhoneSE) }
    }
    @IBInspectable var iPhone8: CGFloat = 0.0 {
        didSet { deviceConstant(.i4_7Inch,value:iPhone8) }
    }
    @IBInspectable var iPhone8Plus: CGFloat = 0.0 {
        didSet { deviceConstant(.i5_5Inch,value:iPhone8Plus) }
    }
    @IBInspectable var iPhoneXS: CGFloat = 0.0 {
        didSet { deviceConstant(.i5_8Inch,value:iPhoneXS) }
    }
    @IBInspectable var iPhoneXR: CGFloat = 0.0 {
        didSet { deviceConstant(.i6_1Inch,value:iPhoneXR) }
    }
    @IBInspectable var iPhoneXMax: CGFloat = 0.0 {
        didSet { deviceConstant(.i6_5Inch,value:iPhoneXMax) }
    }
    
    @IBInspectable var iPhone12: CGFloat = 0.0 {
        didSet { deviceConstant(.i6_6Inch,value:iPhoneXMax) }
    }

    // Helpers
    open func deviceConstant(_ device:UIDeviceSize,value:CGFloat) {
        if deviceSize == device {
            constant = value
        }
    }
}

*/
