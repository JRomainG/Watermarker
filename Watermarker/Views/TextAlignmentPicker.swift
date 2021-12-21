//
//  TextAlignmentPicker.swift
//  Watermarker
//
//  Created by Jean-Romain on 21/12/2021.
//

import SwiftUI

struct TextAlignmentPicker: NSViewRepresentable {

    @Binding var selection: NSTextAlignment
    private let options: [NSTextAlignment] = [.left, .center, .right, .justified]
    private let imageNames = ["TextAlignLeft", "TextAlignCenter", "TextAlignRight", "TextAlignJustified"]

    class Coordinator: NSObject, NSTextStorageDelegate {
        private var parent: TextAlignmentPicker

        init(_ parent: TextAlignmentPicker) {
            self.parent = parent
        }

        @objc func selectionDidChange(sender: NSSegmentedControl) {
            parent.selection = parent.options[sender.selectedSegment]
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSView(context: Context) -> NSSegmentedControl {
        let images = imageNames.map { (name) -> NSImage in
            let image = NSImage(named: name)!
            image.isTemplate = true
            return image
        }
        let control = NSSegmentedControl(
            images: images,
            trackingMode: .selectOne,
            target: context.coordinator,
            action: #selector(context.coordinator.selectionDidChange)
        )
        return control
    }

    func updateNSView(_ nsView: NSSegmentedControl, context: Context) {
        guard let index = options.firstIndex(of: selection), index != nsView.selectedSegment else {
            return
        }
        nsView.selectedSegment = index
    }

}
