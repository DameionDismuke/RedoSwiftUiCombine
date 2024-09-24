//
//  NetworkService.swift
//  ReviewPractice9162024SwiftUI
//
//  Created by Consultant on 9/18/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchHolidays() -> AnyPublisher<[Holidays], NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    func fetchHolidays() -> AnyPublisher<[Holidays], NetworkError> {
        guard let url = URL(string: "https://date.nager.at/api/v2/publicholidays/2024/US") else {
            return Fail(error: NetworkError.badURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in NetworkError.requestFailed }
            .map { $0.data }
            .decode(type: [Holidays].self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingFailed }
            .eraseToAnyPublisher()
    }
}
