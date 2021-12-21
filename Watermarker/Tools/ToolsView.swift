//
//  ToolsView.swift
//  Watermarker
//
//  Created by Jean-Romain on 16/12/2021.
//

import SwiftUI

struct ToolsView: View {

    @ObservedObject var settings: ToolsSettings

    var percentNumberFormatter: NumberFormatter {
        let formatter = TextFieldStepper.defaultNumberFormatter
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter
    }

    var intNumberFormatter: NumberFormatter {
        let formatter = TextFieldStepper.defaultNumberFormatter
        formatter.maximumFractionDigits = 0
        return formatter
    }

    var body: some View {

        // Use bindings to update the shared instance of ToolsSettings and manually handle constraints
        let watermarkText = Binding<String>(get: {
            settings.watermarkText
        }, set: {
            settings.watermarkText = $0
        })
        let fontFamily = Binding<String>(get: {
            settings.fontFamily
        }, set: {
            settings.fontFamily = $0
        })
        let fontStyle = Binding<String>(get: {
            settings.fontStyle
        }, set: {
            settings.fontStyle = $0
        })
        let fontSize = Binding<Double>(get: {
            settings.fontSize
        }, set: {
            settings.fontSize = max(0, min($0, 1000))
        })
        let fontColor = Binding<NSColor>(get: {
            settings.fontColor
        }, set: {
            settings.fontColor = $0
        })
        let textAlignment = Binding<NSTextAlignment>(get: {
            settings.textAlignment
        }, set: {
            settings.textAlignment = $0
        })
        let textRotation = Binding<Double>(get: {
            settings.textRotation
        }, set: {
            // TODO: newRotation.formTruncatingRemainder(360)
            var newRotation = $0
            while newRotation >= 360 {
                newRotation -= 360
            }
            while newRotation < 0 {
                newRotation += 360
            }
            settings.textRotation = newRotation
        })
        let horizontalMirror = Binding<Bool>(get: {
            settings.horizontalMirror
        }, set: {
            settings.horizontalMirror = $0
        })
        let verticalMirror = Binding<Bool>(get: {
            settings.verticalMirror
        }, set: {
            settings.verticalMirror = $0
        })
        let flattenPdf = Binding<Bool>(get: {
            settings.flattenPdf
        }, set: {
            settings.flattenPdf = $0
        })
        let flattenDpi = Binding<Double>(get: {
            settings.flattenDpi
        }, set: {
            settings.flattenDpi = max(1, min($0, 1000))
        })
        let exportFolder = Binding<URL?>(get: {
            settings.exportFolder
        }, set: {
            settings.exportFolder = $0
        })

        // Can't use a List here, otherwise TextFields won't be editable...
        VStack {
            ToolSection("Text") {
                MultilineTextField(text: watermarkText)
            }

            ToolSection("Font") {
                FontPicker(family: fontFamily)

                HStack {
                    FontStylePicker(family: fontFamily.wrappedValue, style: fontStyle)
                    TextFieldStepper("Size", fontSize, range: ClosedRange(uncheckedBounds: (0, 1000)), step: 1)
                }

                TextAlignmentPicker(selection: textAlignment)
            }

            ToolSection("") {
                HStack {
                    Text("Text color")
                        .font(.system(size: NSFont.systemFontSize, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ColorPicker(selectedColor: fontColor)
                        .frame(maxWidth: 45, minHeight: 25, maxHeight: 25)
                }
            }

            ToolSection("Rotation") {
                HStack {
                    Slider(value: textRotation, in: ClosedRange(uncheckedBounds: (0, 359)))
                    TextFieldStepper(
                        "Rotation",
                        textRotation,
                        formatter: intNumberFormatter,
                        range: ClosedRange(uncheckedBounds: (0, 359)),
                        step: 1
                    )
                }
                Toggle("Mirror horizontally", isOn: horizontalMirror)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Toggle("Mirror vertically", isOn: verticalMirror)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ToolSection("Flatten") {
                Toggle("Flatten PDFs", isOn: flattenPdf)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextFieldStepper(
                    "Flattened DPI",
                    flattenDpi,
                    range: ClosedRange(uncheckedBounds: (1, 1000)),
                    step: 1,
                    showLabel: true
                )
            }

            VStack {
                HStack {
                    Button("Select export folder") {
                        exportFolder.wrappedValue = DocumentHelper.showFolderPicker()
                    }
                    Spacer()
                    Button("Export all") {
                        NotificationCenter.default.post(
                            name: .init(DocumentExportObserver.documentExportNotificationName),
                            object: nil
                        )
                    }
                }
                if let exportPath = exportFolder.wrappedValue {
                    Text(exportPath.path)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView(settings: .init())
            .frame(width: 250, height: 500)
    }
}
