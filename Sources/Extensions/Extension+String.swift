//
//  Extension+String.swift
//  Extensions
//
//  Created by ilker on 17.12.2024.
//
import Foundation
import UIKit

extension String {
    /// Returns localized string from legacy strings catalog
    /// - Returns: Localized string if found in Localizable.strings, otherwise returns self
    /// - Note: This extension uses the main bundle and "Localizable.strings" file by default
    public var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: "")
    }
    
    /// Checks if string is empty or contains only whitespace and newline characters
    /// - Returns: True if string is empty or contains only whitespace
    public var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Checks if string contains only numeric characters
    /// - Returns: True if string contains only numbers
    public var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// Checks if string is a valid email format
    /// - Returns: True if string matches basic email pattern
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Converts string to url encoded string
    /// - Returns: URL encoded string or empty string if encoding fails
    public var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    /// Converts string to url decoded string
    /// - Returns: URL decoded string or self if decoding fails
    public var urlDecoded: String {
        return self.removingPercentEncoding ?? self
    }
    
    /// Converts first character of string to uppercase
    /// - Returns: String with first letter capitalized
    public var capitalizedFirst: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    /// Converts string to Base64 encoded string
    /// - Returns: Base64 encoded string
    public var base64Encoded: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Converts Base64 encoded string back to normal string
    /// - Returns: Decoded string or empty string if decoding fails
    public var base64Decoded: String {
        guard let data = Data(base64Encoded: self) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// Extracts all numbers from string
    /// - Returns: String containing only numeric characters
    public var extractNumbers: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    /// Creates an attributed string with the specified color
    /// - Parameter color: UIColor to apply to the string
    /// - Returns: NSAttributedString with the specified color
    public func colored(_ color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
    /// Converts string to slug format (lowercase, no spaces, only hyphens)
    /// - Returns: Slugified string
    public var slugified: String {
        return self.lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .folding(options: .diacriticInsensitive, locale: .current)
            .components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-")))
            .joined()
    }
}
