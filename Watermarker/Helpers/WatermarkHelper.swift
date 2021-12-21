//
//  WatermarkHelper.swift
//  Watermarker
//
//  Created by Jean-Romain on 19/12/2021.
//

import Cocoa

class WatermarkHelper {

    static func watermark(in bounds: CGRect, with context: CGContext) {
        let settings = ToolsSettings.shared

        let fontName = FontHelper.getFullFontName(for: settings.fontFamily, with: settings.fontStyle)
        let fontSize = CGFloat(settings.fontSize)
        let font = NSFont(name: fontName, size: fontSize) ?? NSFont.systemFont(ofSize: fontSize)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = settings.textAlignment

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: settings.fontColor
        ]
        let attributedText = NSAttributedString(string: settings.watermarkText, attributes: attributes)
        let textSize = attributedText.size()

        // We can't use "attributedText.draw(at: textPosition)" because we want to be able to specify the cgContext
        // Instead, we use the CoreText methods directly
        let textRect = CGRect(
            x: -textSize.width / 2,
            y: -textSize.height / 2 - font.ascender,
            width: textSize.width,
            height: textSize.height + font.capHeight
        )
        let textPath = CGPath(rect: textRect, transform: nil)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textPath, nil)

        context.saveGState()

        // Change context origin to be the center of the document
        context.translateBy(x: bounds.size.width / 2, y: bounds.size.height / 2)

        // Rotate and scale the context using the user settings
        // Because we translated our context, the rotation is now relative to the center of the page
        context.rotate(by: CGFloat(settings.textRotation) * CGFloat.pi / 180.0)
        context.scaleBy(
            x: settings.horizontalMirror ? -1.0 : 1.0,
            y: settings.verticalMirror ? -1.0 : 1.0
        )

        // Draw the text, which will now be centered and rotated
        CTFrameDraw(frame, context)

        context.restoreGState()
    }

}
