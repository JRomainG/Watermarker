//
//  ImageMarker.swift
//  Watermarker
//
//  Created by Jean-Romain on 19/12/2021.
//

import SwiftUI
import CoreGraphics

class ImageWatermarker: NSImageView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        WatermarkHelper.watermark(in: dirtyRect, with: context)
    }

}

extension NSImage {

    func watermarked() -> NSImage? {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: cgImage.bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }

        context.interpolationQuality = .high
        context.setFillColor(.clear)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.draw(cgImage, in: rect)
        WatermarkHelper.watermark(in: rect, with: context)

        guard let renderedImage = context.makeImage() else {
            return nil
        }
        return NSImage(cgImage: renderedImage, size: size)
    }

    func write(to url: URL) throws -> Bool {
        let properties: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: 1.0
        ]

        guard let imageData = tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: imageData),
            let data = imageRep.representation(using: .png, properties: properties) else {
            return false
        }

        try data.write(to: url)
        return true
    }

}
