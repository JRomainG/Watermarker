//
//  ToolsHostingController.swift
//  Watermarker
//
//  Created by Jean-Romain on 16/12/2021.
//

import SwiftUI

class ToolsHostingController: NSHostingController<ToolsViewContainer> {

    @objc required dynamic init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ToolsViewContainer())
    }

}
