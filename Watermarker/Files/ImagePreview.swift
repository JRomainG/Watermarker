//
//  ImagePreview.swift
//  Watermarker
//
//  Created by Jean-Romain on 17/12/2021.
//

import SwiftUI

struct ImagePreview: View {

    var image: Document
    @State private var previewSize: CGSize = .zero

    var body: some View {
        ImageView(url: image.url, previewSize: $previewSize, settings: ToolsSettings.shared)
            .frame(maxWidth: previewSize.width, maxHeight: previewSize.height)
    }

    struct ImageView: NSViewRepresentable {

        let url: URL
        @Binding var previewSize: CGSize
        @ObservedObject var settings: ToolsSettings

        func updatePreviewSize(_ image: NSImage) {
            // Avoid "Modifying state during view update" runtime error
            DispatchQueue.main.async {
                previewSize = image.size
            }
        }

        func makeNSView(context: Context) -> NSImageView {
            let image = NSImage(contentsOf: url)!
            let view = ImageWatermarker(image: image)
            updatePreviewSize(image)
            return view
        }

        func updateNSView(_ nsView: NSImageView, context: Context) {
            nsView.needsDisplay = true
        }

    }

}

struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        let file = Document(url: URL(fileURLWithPath: "/tmp"), type: .image)
        ImagePreview(image: file)
    }
}
