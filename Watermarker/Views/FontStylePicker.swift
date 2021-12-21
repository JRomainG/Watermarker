//
//  FontStylePicker.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import SwiftUI

struct FontStylePicker: View {

    var family: String
    @Binding var style: String

    var body: some View {
        let availableStyles = FontHelper.getFontStyleNames(for: family)
        PopUpButton(items: availableStyles, selection: $style)
    }

}

struct FontStylePicker_Previews: PreviewProvider {
    static var previews: some View {
        FontStylePicker(family: "Helvetica", style: .constant("Regular"))
    }
}
