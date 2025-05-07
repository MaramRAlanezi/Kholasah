//
//  Recording.swift
//  Recording_test
//
//  Created by Reuof on 06/05/2025.
//


import Foundation

struct Recording {
    let fileURL: URL
    let createdAt: Date
}

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}
