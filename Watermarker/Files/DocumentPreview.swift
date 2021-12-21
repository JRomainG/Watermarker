//
//  DocumentPreview.swift
//  Watermarker
//
//  Created by Jean-Romain on 17/12/2021.
//

import SwiftUI
import OrderedCollections

struct DocumentPreview: View {

    @Binding var files: OrderedSet<Document>
    var file: Document
    @Binding var isExporting: Bool

    var body: some View {
        VStack {
            switch file.type {
            case .pdf:
                PdfPreview(pdf: file)
            case .image:
                ImagePreview(image: file)
            case .unknown:
                Text("Unknown document at \(file.url.absoluteString)")
            }

            HStack {
                Button("×") {
                    files.remove(file)
                }
                .disabled(isExporting)
                Text(file.url.path)
            }
            .frame(maxWidth: .infinity)
        }
    }

}

struct DocumentPreview_Previews: PreviewProvider {
    static var previews: some View {
        let file = Document(url: URL(fileURLWithPath: "/tmp"), type: .unknown)
        DocumentPreview(files: .constant([file]), file: file, isExporting: .constant(false))
    }
}
