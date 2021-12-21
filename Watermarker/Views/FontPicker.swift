//
//  FontPicker.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import SwiftUI

struct FontPicker: View {

    private let availableFonts = FontHelper.availableFonts
    @Binding var family: String

    var body: some View {
        // The regular SwiftUI Picker is *extremely* slow when there are large amounts of items
        // Thus, we use an NSViewRepresentable to wrap a NSPopUpButton, which is much more efficient
        PopUpButton(items: availableFonts, selection: $family, dynamicFont: true)
    }

}

struct FontPicker_Previews: PreviewProvider {
    static var previews: some View {
        FontPicker(family: .constant("Helvetica"))
            .frame(width: 250, height: 50)
            .padding(.horizontal, 10)
    }
}
