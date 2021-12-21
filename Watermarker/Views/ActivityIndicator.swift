//
//  ActivityIndicator.swift
//  Watermarker
//
//  Created by Jean-Romain on 21/12/2021.
//

import SwiftUI

struct ActivityIndicator: NSViewRepresentable {

    var isAnimating: Bool

    func makeNSView(context: Context) -> NSProgressIndicator {
        let view = NSProgressIndicator()
        view.style = .spinning
        view.controlSize = .small
        return view
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        isAnimating ? nsView.startAnimation(nsView) : nsView.stopAnimation(nsView)
    }

}
