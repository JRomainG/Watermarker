//
//  PopUpButton.swift
//  Watermarker
//
//  Created by Jean-Romain on 19/12/2021.
//

import SwiftUI

struct PopUpButton: NSViewRepresentable {

    var items: [String]
    @Binding var selection: String
    var dynamicFont = false

    class Coordinator {
        private var parent: PopUpButton

        init(_ parent: PopUpButton) {
            self.parent = parent
        }

        @objc func dropdownItemSelected(_ notification: NSNotification) {
            guard let menuItem = notification.userInfo?["MenuItem"] as? NSMenuItem else {
                return
            }
            parent.selection = menuItem.title
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func updateItems(_ button: NSPopUpButton) {
        // Removing items, adding them back, and setting the font is slow, so first make sure it's really necessary
        guard button.itemTitles != items else {
            return
        }
        button.removeAllItems()
        button.addItems(withTitles: items)
        updateItemFonts(button)
    }

    func updateItemFonts(_ button: NSPopUpButton) {
        guard dynamicFont == true else {
            return
        }
        for item in button.itemArray {
            let font = NSFont(name: item.title, size: NSFont.systemFontSize)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
            ]
            item.attributedTitle = NSAttributedString(string: item.title, attributes: attributes)
        }
    }

    func updateSelection(_ button: NSPopUpButton, selection: String) {
        guard button.selectedItem?.title != selection,
              let matchedMenuItem = button.item(withTitle: selection) else {
            return
        }
        button.select(matchedMenuItem)
    }

    func makeNSView(context: Context) -> NSPopUpButton {
        let button = NSPopUpButton()

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.dropdownItemSelected),
            name: NSMenu.didSendActionNotification,
            object: button.menu
        )

        updateItems(button)
        updateSelection(button, selection: selection)
        return button
    }

    func updateNSView(_ nsView: NSPopUpButton, context: Context) {
        updateItems(nsView)
        updateSelection(nsView, selection: selection)
    }

}
