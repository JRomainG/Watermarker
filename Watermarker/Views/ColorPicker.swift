//
//  ColorPicker.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import SwiftUI

struct ColorPicker: NSViewRepresentable {

    @Binding var selectedColor: NSColor

    class Coordinator: NSObject, NSTextStorageDelegate {
        private var parent: ColorPicker

        init(_ parent: ColorPicker) {
            self.parent = parent
            NSColorPanel.shared.setAction(#selector(colorUpdate))
            NSColorPanel.shared.showsAlpha = true
        }

        @objc func colorUpdate(panel: NSColorPanel) {
            parent.colorUpdate(color: panel.color)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell()
        NSColorPanel.shared.setTarget(context.coordinator)
        return colorWell
    }

    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = selectedColor
    }

    func colorUpdate(color: NSColor) {
        selectedColor = color
    }

}
