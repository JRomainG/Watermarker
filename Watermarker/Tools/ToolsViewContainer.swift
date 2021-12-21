//
//  ToolsViewContainer.swift
//  Watermarker
//
//  Created by Jean-Romain on 16/12/2021.
//

import SwiftUI

struct ToolsViewContainer: View {

    private let toolsViewWidth: CGFloat = 250

    var body: some View {
        ScrollView {
            ToolsView(settings: ToolsSettings.shared)
                .frame(minWidth: toolsViewWidth, maxWidth: toolsViewWidth, maxHeight: .infinity)
        }
    }

}

struct ToolsViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ToolsViewContainer()
    }
}
