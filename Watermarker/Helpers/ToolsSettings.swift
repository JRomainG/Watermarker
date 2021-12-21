//
//  ToolsSettings.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import SwiftUI

class ToolsSettings: ObservableObject {

    static let shared = ToolsSettings()

    @Published var watermarkText = "Watermark"
    @Published var fontFamily = "Helvetica"
    @Published var fontStyle = "Regular"
    @Published var fontSize = 64.0
    @Published var fontColor = NSColor(red: 1, green: 0, blue: 0, alpha: 0.6)
    @Published var textAlignment = NSTextAlignment.center
    @Published var textRotation = 45.0
    @Published var horizontalMirror = false
    @Published var verticalMirror = false
    @Published var flattenPdf = true
    @Published var flattenDpi = 72.0
    @Published var exportFolder: URL? = nil

}
