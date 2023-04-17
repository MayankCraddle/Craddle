//
//  String+Extension.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 29/07/22.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

extension String {
    func isUppercased(at: Index) -> Bool {
        let range = at..<self.index(after: at)
        return self.rangeOfCharacter(from: .uppercaseLetters, options: [], range: range) != nil
    }
    
    func isLowercased(at: Index) -> Bool {
        let range = at..<self.index(after: at)
        return self.rangeOfCharacter(from: .lowercaseLetters, options: [], range: range) != nil
    }
    
    func isSpecial() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
    
    var isAlphbetsOnly: Bool {
        if (self.rangeOfCharacter(from: CharacterSet.letters) != nil) {
            return true
        }
        return false
    }
    
    
    var isValidPassword : Bool {
        if self.filter({ $0.isUppercase }) == "" || self.filter({ $0.isLowercase }) == "" || self.count > 30 || self.count < 8 { //!self.isContainAnyNumber {
            return false
        }else{
            return true
        }
    }
    
    ///This allowed only characters
    //    var isValidName: Bool {
    //
    //        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ' '")
    //        if self.rangeOfCharacter(from: set.inverted) != nil {
    //            return false
    //        }
    //
    //        return true
    //
    //    }
    
    var isValidUserName : Bool {
        if self.contains(" "){
            return false
        }
        return true
        
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
        
    }
    
    ///It return true if phone number between 4 to 15 otherwise flase
    var isValidPhone : Bool {
        if self.count > 7 && self.count < 16{
            return true
        }
        return false
    }
    
    var isValidName : Bool {
        if self.count >= 3 && self.count <= 30{
            return true
        }
        return false
    }
    
    
    func UTCToLocal(formate : String , dateFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        if dt != nil {
            return dateFormatter.string(from: dt!)
        }
        return ""
    }
    
    func getDateInstance(validFormate:String)-> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = validFormate
        dateFormater.date(from:self)
        return dateFormater.date(from:self)
    }
    
    /*
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Constant.kCurrentLanguage == "en" ? Locale(identifier: "en_US") : Locale(identifier: "es_CL")
     dateFormatter.dateFormat = validDateFormatter //"dd MMM yyyy" //yyyy-mm-dd hh:mm
     return dateFormatter.string(from: self as Date)
     */
    
    func getDateInstanceFromISO()-> Date? {
        let dateFormater = ISO8601DateFormatter()//DateFormatter()
//        dateFormater.dateFormat = validFormate
        dateFormater.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let newDate = dateFormater.date(from:self)
        
        guard newDate != nil else {  return nil }
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier:  LanguageUtil.appCurrentLanguageString)
        let stringDate = dateFormatter.string(from: newDate!)
        
        return dateFormatter.date(from: stringDate)
//        return dateFormater.date(from:self)
    }
    
    func getDateInstanceInTime() -> Date? {
        let arrTime = self.components(separatedBy: ":")
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = arrTime.count == 2 ? "HH:mm" : "HH:mm:ss"
        return dateFormater.date(from: self)
    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isContainAnyNumber : Bool{
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            return true
        }
        else{
            return false
        }
    }
    
    func fromBase64() -> String?{
        let sDecode = self.removingPercentEncoding
        return sDecode
    }
    
    func convertToEnglishNumber() -> NSNumber? {
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        
        return Formatter.number(from: self)
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            var labelHeight = placeholderLabel.frame.height
//            let isDeviceType = getDeviceType()
//            if isDeviceType == "iPad"
//            {
//                labelHeight = placeholderLabel.frame.height + 20
//            }
//            else
//            {
//                labelHeight = placeholderLabel.frame.height
//            }
            
            
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
