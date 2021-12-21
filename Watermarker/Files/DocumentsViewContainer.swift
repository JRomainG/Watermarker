//
//  DocumentsViewContainer.swift
//  Watermarker
//
//  Created by Jean-Romain on 16/12/2021.
//

import PDFKit
import SwiftUI
import OrderedCollections

struct DocumentsViewContainer: View {

    @State private var files: OrderedSet<Document> = []
    @State private var isDropping = false
    @State private var isExporting = false

    var body: some View {
        let dropDelegate = FilesDropDelegate(files: $files, isDropping: $isDropping)

        ZStack {
            if self.files.count > 0 {
                DocumentsView(files: $files, isExporting: $isExporting)
                    .onExport { (notification) in
                        exportDocuments()
                    }
            } else {
                VStack {
                    Text("Drag and drop image or pdf files")
                        .font(.callout)
                        .padding(.bottom, 10)
                    Text("or")
                        .font(.caption)
                    Button("Select files") {
                        let newFiles = DocumentHelper.showDocumentPicker()
                        files.formUnion(newFiles)
                    }
                }
            }

            // Add a "glow" when the view receives files through drag and drop
            if isDropping && !isExporting {
                Rectangle()
                    .stroke(Color(.selectedControlColor), lineWidth: 5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: ["public.file-url"], delegate: dropDelegate)
    }

    func exportDocuments() {
        if isExporting {
            return
        }
        isExporting = true

        DispatchQueue.global(qos: .userInitiated).async {
            for file in files {
                do {
                    switch file.type {
                    case .pdf:
                        try exportPdf(pdf: file)
                    case .image:
                        try exportImage(image: file)
                    case .unknown:
                        throw ExportError.unknown(filePath: file.url, exportPath: nil)
                    }
                } catch {
                    AlertHelper.showError(error)
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               isExporting = false
            }
        }
    }

    func exportPdf(pdf: Document) throws {
        guard var document = PDFDocument(url: pdf.url) else {
            throw ExportError.readError(filePath: pdf.url)
        }
        let exportFilePath = try DocumentHelper.makeExportPath(originalUrl: pdf.url)
        let delegate = PdfWatermarkerDelegate.shared
        document.delegate = delegate
        if ToolsSettings.shared.flattenPdf {
            document = try document.flattened(with: CGFloat(ToolsSettings.shared.flattenDpi))
        }
        if !document.write(to: exportFilePath) {
            throw ExportError.unknown(filePath: pdf.url, exportPath: exportFilePath)
        }
    }

    func exportImage(image: Document) throws {
        guard let originalImage = NSImage(contentsOf: image.url) else {
            throw ExportError.readError(filePath: image.url)
        }
        guard let watermarkedImage = originalImage.watermarked() else {
            throw ExportError.renderError(filePath: image.url)
        }
        let exportFilePath = try DocumentHelper.makeExportPath(originalUrl: image.url)
        if try !watermarkedImage.write(to: exportFilePath) {
            throw ExportError.unknown(filePath: image.url, exportPath: exportFilePath)
        }
    }

    struct FilesDropDelegate: DropDelegate {

        @Binding var files: OrderedSet<Document>
        @Binding var isDropping: Bool

        func addFile(_ url: URL) {
            let fileType = DocumentHelper.documentType(from: url)
            guard fileType != .unknown else {
                return
            }
            let file = Document(url: url, type: fileType)
            files.append(file)
        }

        // MARK: - Drag and drop callbacks
        func validateDrop(info: DropInfo) -> Bool {
            // We can't check for DocumentsViewContainer.allowedFileTypes here because it hasn't been resolved
            // It is done manually in performDrop for each file
            return info.hasItemsConforming(to: ["public.file-url"])
        }

        func dropEntered(info: DropInfo) {
            isDropping = true
        }

        func performDrop(info: DropInfo) -> Bool {
            let providers = info.itemProviders(for: ["public.file-url"])
            for item in providers {
                item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    DispatchQueue.main.async {
                        if let urlData = urlData as? Data {
                            let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                            addFile(url)
                        }
                    }
                }
            }
            return providers.count > 0
        }

        func dropExited(info: DropInfo) {
            isDropping = false
        }

    }

}

struct DocumentsViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsViewContainer()
    }
}
