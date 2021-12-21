//
//  DocumentsView.swift
//  Watermarker
//
//  Created by Jean-Romain on 16/12/2021.
//

import SwiftUI
import OrderedCollections

struct DocumentsView: View {

    @Binding var files: OrderedSet<Document>
    @Binding var isExporting: Bool
    private let exportObserver = DocumentExportObserver()

    var body: some View {
        VStack {
            List(files) { file in
                DocumentPreview(files: $files, file: file, isExporting: $isExporting)
                    .padding(.vertical, 10)
            }

            Divider()
                .offset(x: 0, y: -8)

            HStack {
                if isExporting {
                    ActivityIndicator(isAnimating: true)
                    Text("Exporting...")
                        .font(.callout)
                } else {
                    Text("＋ Drag and drop here")
                        .font(.callout)
                    Text("or")
                        .font(.caption)
                    Button("Select more files") {
                        let newFiles = DocumentHelper.showDocumentPicker()
                        files.formUnion(newFiles)
                    }
                }
            }
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
        }
        .listStyle(SidebarListStyle())
    }

    func `onExport`(perform action: @escaping (NSNotification) -> Void) -> Self {
        exportObserver.action = action
        return self
    }

}

struct DocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsView(files: .constant([]), isExporting: .constant(false))
    }
}
