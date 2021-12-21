//
//  DocumentHelper.swift
//  Watermarker
//
//  Created by Jean-Romain on 17/12/2021.
//

import SwiftUI

enum DocumentType: String {
    case pdf = "com.adobe.pdf"
    case image = "public.image"
    case unknown
}

struct Document: Hashable, Identifiable {

    var id: String {
        return url.absoluteString
    }

    let url: URL
    let type: DocumentType

    func hash(into hasher: inout Hasher) {
        hasher.combine(url.absoluteString)
    }

}

class DocumentHelper {

    static let allowedDocumentTypes: [DocumentType] = [.pdf, .image]

    static func documentType(from url: URL) -> DocumentType {
        let fileType: String
        do {
            fileType = try url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier ?? ""
        } catch {
            return .unknown
        }

        for allowedType in allowedDocumentTypes {
            if UTTypeConformsTo(fileType as CFString, allowedType.rawValue as CFString) {
                return allowedType
            }
        }

        return .unknown
    }

    static func showDocumentPicker() -> [Document] {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedFileTypes = DocumentHelper.allowedDocumentTypes.map(\.rawValue)
        panel.resolvesAliases = true
        panel.allowsMultipleSelection = true

        guard panel.runModal() == .OK else {
            return []
        }

        var files: [Document] = []
        for url in panel.urls {
            let fileType = DocumentHelper.documentType(from: url)
            guard fileType != .unknown else {
                continue
            }
            let file = Document(url: url, type: fileType)
            files.append(file)
        }
        return files
    }

    static func showFolderPicker() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.resolvesAliases = true
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK else {
            return nil
        }
        return panel.url
    }

    static var downloadsPath: URL? {
        do {
            return try DocumentHelper.getDownloadsPath()
        } catch {
            return nil
        }
    }

    static func getDownloadsPath() throws -> URL {
        return try FileManager.default.url(
            for: .downloadsDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }

    static func makeExportPath(originalUrl: URL) throws -> URL {
        let basePath = try ToolsSettings.shared.exportFolder ?? DocumentHelper.getDownloadsPath()
        let originalFileName = originalUrl.deletingPathExtension().lastPathComponent
        let originalExtension = originalUrl.pathExtension
        var fileName = "\(originalFileName) - marked.\(originalExtension)"
        var url = basePath.appendingPathComponent(fileName)
        var i = 0
        while FileManager.default.fileExists(atPath: url.absoluteURL.path) {
            i += 1
            fileName = "\(originalFileName) - marked (\(i)).\(originalExtension)"
            url = basePath.appendingPathComponent(fileName)
        }
        return url.absoluteURL
    }

}

enum ExportError: Error {
    case readError(filePath: URL)
    case renderError(filePath: URL)
    case unknown(filePath: URL, exportPath: URL?)
}

extension ExportError {

    public var errorDescription: String {
        switch self {
        case .readError(filePath: let filePath):
            return "Failed to read file at\(filePath.path)"
        case .renderError(filePath: let filePath):
            return "Failed to render watermark for file at \(filePath.path)"
        case .unknown(filePath: let filePath, exportPath: let exportPath): do {
            if exportPath != nil {
                return "An unknown error occurred while exporting file at \(filePath.path) to \(exportPath!.path)"
            } else {
                return "An unknown error occurred while exporting file at \(filePath.path)"
            }
        }
        }
    }

}


class DocumentExportObserver {

    static let documentExportNotificationName = "com.justkodding.watermarker.ExportNotification"
    var action: ((NSNotification) -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(documentExportRequested),
            name: .init(DocumentExportObserver.documentExportNotificationName),
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func documentExportRequested(_ notification: NSNotification) {
        action?(notification)
    }

}
