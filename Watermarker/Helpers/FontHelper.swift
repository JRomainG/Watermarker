//
//  FontHelper.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import Cocoa

class FontHelper {

    static let availableFonts = NSFontManager.shared.availableFontFamilies

    static func getFontStyleNames(for family: String) -> [String] {
        guard let styles = NSFontManager.shared.availableMembers(ofFontFamily: family) else {
            return []
        }
        return styles.map { (info) -> String in
            return info[1] as! String
        }
    }

    static func getFullFontName(for family: String, with style: String?) -> String {
        guard style != nil else {
            return family
        }
        guard let styles = NSFontManager.shared.availableMembers(ofFontFamily: family) else {
            return family
        }
        let fontInfo = styles.first { (info) -> Bool in
            let fontStyle = info[1] as! String
            return fontStyle == style
        }
        guard let fullName = fontInfo?.first else {
            return family
        }
        return fullName as! String
    }

}
