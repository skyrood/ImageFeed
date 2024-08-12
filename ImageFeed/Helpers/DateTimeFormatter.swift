//
//  DateTimeFormatter.swift
//  ImageFeed
//
//  Created by Rodion Kim on 12/08/2024.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    
    return dateFormatter.string(from: date)
}
