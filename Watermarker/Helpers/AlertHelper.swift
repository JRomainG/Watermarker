//
//  AlertHelper.swift
//  Watermarker
//
//  Created by Jean-Romain on 21/12/2021.
//

import Cocoa

class AlertHelper {

    static func showError(_ error: Error) {
        let alert = NSAlert(error: error)
        alert.alertStyle = .critical
        alert.runModal()
    }

    static func showError(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = title
        alert.informativeText = message
        alert.runModal()
    }

}
