//
//  ToolSection.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import SwiftUI

struct ToolSection<Content: View>: View {

    var title: String
    let content: () -> Content

    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        if !title.isEmpty {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: NSFont.systemFontSize, weight: .medium))
        }

        content()

        Divider()
            .padding(.vertical, 10)
    }

}

struct ToolSection_Previews: PreviewProvider {
    static var previews: some View {
        ToolSection("Title") {
            Text("Content")
        }
    }
}
