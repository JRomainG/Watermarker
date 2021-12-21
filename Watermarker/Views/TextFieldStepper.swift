//
//  TextFieldStepper.swift
//  Watermarker
//
//  Created by Jean-Romain on 18/12/2021.
//

import SwiftUI

struct TextFieldStepper: View {

    var title: String
    var formatter: NumberFormatter
    var value: Binding<Double>
    var range: ClosedRange<Double>
    var step: Double
    var showLabel: Bool

    static var defaultNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        return formatter
    }

    init(_ title: String,
         _ value: Binding<Double>,
         formatter: NumberFormatter? = nil,
         range: ClosedRange<Double> = ClosedRange(uncheckedBounds: (0, 1)),
         step: Double = 0.01,
         showLabel: Bool = false) {
        self.title = title
        self.value = value
        self.formatter = formatter ?? TextFieldStepper.defaultNumberFormatter
        self.range = range
        self.step = step
        self.showLabel = showLabel
    }

    var body: some View {
        HStack {
            if showLabel {
                Text(self.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            TextField("Size", value: value, formatter: formatter)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 48)
                .offset(x: 5, y: 0)

            Stepper("", value: value, in: range, step: step)
                .labelsHidden()
        }
    }

}

struct TextFieldStepper_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldStepper("Title", .constant(0))
    }
}
