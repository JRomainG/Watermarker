//
//  PdfMarker.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import PDFKit
import SwiftUI

class PdfWatermarkerDelegate: ViewController, PDFDocumentDelegate {

    static let shared = PdfWatermarkerDelegate()

    func classForPage() -> AnyClass {
        return PdfWatermarkerPage.self
    }

}

class PdfWatermarkerPage: PDFPage {

    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        super.draw(with: box, to: context)
        let pageBounds = bounds(for: box)
        WatermarkHelper.watermark(in: pageBounds, with: context)
    }

}

extension PDFPage {

    func flattened(with dpi: CGFloat) -> NSImage? {
        let pageRect = bounds(for: .mediaBox)
        let scale = dpi / 72.0
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let imageSize = pageRect.size.applying(scaleTransform)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: Int(imageSize.width),
            height: Int(imageSize.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }

        context.interpolationQuality = .high
        context.setFillColor(.white)
        context.scaleBy(x: scale, y: scale)

        context.fill(pageRect)
        draw(with: .mediaBox, to: context)

        guard let image = context.makeImage() else {
            return nil
        }
        return NSImage(cgImage: image, size: imageSize)
    }

}

extension PDFDocument {

    func flattened(with dpi: CGFloat) throws -> PDFDocument {
        let flattenedDocument = PDFDocument()
        for pageIndex in 0..<pageCount {
            if let oldPage = page(at: pageIndex),
               let image = oldPage.flattened(with: dpi),
               let flattenedPage = PDFPage(image: image) {
                flattenedDocument.insert(flattenedPage, at: flattenedDocument.pageCount)
            } else {
                throw ExportError.renderError(filePath: documentURL!)
            }
        }
        return flattenedDocument
    }

}
