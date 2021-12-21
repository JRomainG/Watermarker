//
//  MultilineTextField.swift
//  Watermarker
//
//  Created by Jean-Romain on 21/12/2021.
//

import SwiftUI

struct MultilineTextField: NSViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, NSTextFieldDelegate {
        private var parent: MultilineTextField
        var textField: NSTextField?

        init(_ parent: MultilineTextField) {
            self.parent = parent
        }

        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if (commandSelector == #selector(textField?.insertNewline)) {
                textView.insertNewlineIgnoringFieldEditor(self)
                return true
            } else if (commandSelector == #selector(textField?.insertTab)) {
                textView.insertTabIgnoringFieldEditor(self)
                return true
            }
            return false
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else {
                return
            }
            parent.text = textField.stringValue
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let view = NSTextField(string: text)
        view.delegate = context.coordinator
        context.coordinator.textField = view
        return view
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        if text != nsView.stringValue {
            nsView.stringValue = text
        }
    }

}
