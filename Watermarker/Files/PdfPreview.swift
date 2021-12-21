//
//  PdfPreview.swift
//  Watermarker
//
//  Created by Jean-Romain on 17/12/2021.
//

import PDFKit
import SwiftUI

struct PdfPreview: View {

    var pdf: Document
    @State private var previewSize: CGSize = .zero

    var body: some View {
        PdfView(url: pdf.url, previewSize: $previewSize, settings: ToolsSettings.shared)
            .frame(maxWidth: previewSize.width, idealHeight: previewSize.height)
    }

    struct PdfView: NSViewRepresentable {

        let url: URL
        @Binding var previewSize: CGSize
        @ObservedObject var settings: ToolsSettings

        func pdfDocument(from url: URL) -> PDFDocument? {
            let document = PDFDocument(url: url)
            document?.delegate = PdfWatermarkerDelegate.shared
            return document
        }

        func updatePreviewSize(_ pdfView: PDFView) {
            if let page = pdfView.document?.page(at: 0) {
                // Avoid "Modifying state during view update" runtime error
                DispatchQueue.main.async {
                    previewSize = pdfView.rowSize(for: page)
                }
            }
        }

        func makeNSView(context: Context) -> PDFView {
            let pdfView = PDFView()
            pdfView.document = pdfDocument(from: url)
            pdfView.autoScales = false
            pdfView.displayMode = .singlePageContinuous
            pdfView.acceptsDraggedFiles = false
            pdfView.backgroundColor = .clear
            pdfView.enclosingScrollView?.backgroundColor = .clear

            updatePreviewSize(pdfView)
            return pdfView
        }

        func updateNSView(_ nsView: PDFView, context: Context) {
            if url != nsView.document?.documentURL {
                nsView.document = pdfDocument(from: url)
                updatePreviewSize(nsView)
            }
            nsView.needsDisplay = true
        }

    }

}

struct PdfPreview_Previews: PreviewProvider {
    static var previews: some View {
        let file = Document(url: URL(fileURLWithPath: "/tmp"), type: .pdf)
        PdfPreview(pdf: file)
    }
}
