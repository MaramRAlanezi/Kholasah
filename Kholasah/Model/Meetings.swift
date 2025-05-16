//
//  Meetings.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 18/11/1446 AH.
//
import Foundation

struct Meeting: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var date: String
    var time: String
    var duration: String
}

