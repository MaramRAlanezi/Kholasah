//
//  Date+Extension.swift
//  Recording_test
//
//  Created by Reuof on 06/05/2025.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
