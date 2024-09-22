//
//  networkErrorProcessor.swift
//  ImageFeed
//
//  Created by Rodion Kim on 19/09/2024.
//

func networkErrorLogger(_ error: Error) {
    if let networkError = error as? NetworkError {
        switch networkError {
        case .httpStatusCode(let statusCode):
            print("Received HTTP error with status code: \(statusCode)")
        case .urlRequestError(let requestError):
            print("URL Request error occurred: \(requestError.localizedDescription)")
        case .urlSessionError:
            print("An unknown URLSession error occurred.")
        }
    } else {
        print("An unknown error occurred: \(error.localizedDescription)")
    }
}
