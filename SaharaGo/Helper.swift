//
//  Helper.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/07/22.
//

import Foundation
import UIKit

var APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

func print_debug<T>(_ obj:T,file: String = #file, line: Int = #line, function: String = #function) {
//    print("File:'\(file.description)' Line:'\(line)' Function:'\(function)' ::\(obj)")
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func feedColor() {
    guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {
        let defaultCountryColorStr = "rgba(119,77,41,1)"
        guard let rgba = defaultCountryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        selectedCountryColor =  UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        return
    }
    guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
    let myStringArr = rgba.components(separatedBy: ",")
    selectedCountryColor =  UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    
}

func isPasswordValid(_ password : String) -> Bool{
//    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#.])[A-Za-z\\dd$@$!%*?&#._;<>(){}-~`?/:+=]{8,}")

    return passwordTest.evaluate(with: password)
}
