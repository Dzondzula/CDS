//
//  UIColor+WhiteLabel.swift
//  
//
//  Created by Nikola Andrijašević on 26.11.23..
//

import UIKit

public extension UIColor {

    /// Initialize color with identifier
    ///
    /// - Parameter identifier: color identifier to use for color creation
    convenience init(identifier: Color.Identifier, coordinator: ThemeCoordinator? = CoreWL.shared) {
        if let color = (coordinator ?? CoreWL.shared).color(identifier: identifier) {
            self.init(color: color)
        } else {
            self.init(white: 0, alpha: 0)
        }
    }

    convenience init(color: Color?) {
        if let color = color {
            self.init(hexStr: color.hex, opacity: color.opacity)
        } else {
            self.init(white: 0, alpha: 0)
        }
    }

    /// Initialize color with style identifier
    ///
    /// - Parameter textStyle: text style identifier
    convenience init(textStyle: TextStyle.Identifier, coordinator: ThemeCoordinator? = CoreWL.shared) {
        if let textStyle = (coordinator ?? CoreWL.shared).textStyle(identifier: textStyle) {
            self.init(textStyle: textStyle, coordinator: coordinator)
        } else {
            self.init(white: 0, alpha: 0)
        }
    }


    /// Initialize color with style identifier
    ///
    /// - Parameter textStyle: text style identifier
    convenience init(textStyle: TextStyle?, coordinator: ThemeCoordinator? = CoreWL.shared) {
        if let rawIdentifier = textStyle?.colorIdentifier,
           let colorIdentifier = Color.Identifier(rawValue: rawIdentifier),
           let color = (coordinator ?? CoreWL.shared).color(identifier: colorIdentifier) {
            self.init(hexStr: color.hex)
        } else {
            self.init(white: 0, alpha: 0)
        }
    }
}

public extension UIColor {

    /// Initialize `UIColor` object with RGB values.
    /// - Parameters:
    ///   - red: red value between 0..255
    ///   - green: green value between 0..255
    ///   - blue: blue value between 0..255
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    /// Initialize `UIColor` object with hex value.
    /// - Parameter hexNum: color hex int value
    convenience init(hexNum: Int) {
        self.init(red:(hexNum >> 16) & 0xff, green:(hexNum >> 8) & 0xff, blue:hexNum & 0xff)
    }

    /// Initialize `UIColor` object with hex value.
    /// - Parameter hexStr: color hex string value
    convenience init(hexStr: String, opacity: CGFloat = 1.0) {
        var cString: String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        let redValue: CGFloat = {
            var toReturn = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            if cString.count == 8 {
                toReturn = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            }
            return toReturn
        }()

        let greenValue: CGFloat = {
            var toReturn = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            if cString.count == 8 {
                toReturn = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            }
            return toReturn
        }()

        let blueValue: CGFloat = {
            var toReturn = CGFloat(rgbValue & 0x0000FF) / 255.0
            if cString.count == 8 {
                toReturn = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            }
            return toReturn
        }()

        let alpha: CGFloat = {
            var toReturn = opacity
            if cString.count == 8 {
                toReturn =  CGFloat(rgbValue & 0x000000FF) / 255.0
            }
            return toReturn
        }()

        self.init(
            red: redValue,
            green: greenValue,
            blue: blueValue,
            alpha: alpha
        )
    }

    /// Get RGB values of a color.
    /// - Returns: RGB values tupple
    func rgba() -> (red: Int, green: Int, blue: Int, alpha: CGFloat) {
        var red:   CGFloat = 0
        var green: CGFloat = 0
        var blue:  CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: Int(red * 255), green: Int(green * 255), blue : Int(blue * 255), alpha : alpha)
    }

    /// String description of a color RGB values
    /// - Returns: string description
    func commaSeparatedRGBARepresentation() -> String {
        let colorTouple = self.rgba()

        return "\(colorTouple.red), \(colorTouple.green), \(colorTouple.blue), \(colorTouple.alpha)"
    }
}






























