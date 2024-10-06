//
//  Date+Extension.swift
//  ImageFeed
//
//  Created by Rodion Kim on 05/10/2024.
//

import Foundation

private let isoFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.timeZone = .current
    return dateFormatter
}()

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}

extension String {
    func toFormattedDateString() -> String? {
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        return date.dateTimeString
    }
    
    func toDate() -> Date? {
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        return date
    }
}
