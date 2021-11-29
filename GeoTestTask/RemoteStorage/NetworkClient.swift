//
//  NetworkService.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

import RxSwift

enum NetworkError: Error {
    case badURL
    case unknown
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: String) -> Observable<T>
}

public class NetworkClient: NetworkServiceProtocol {
    private let session = URLSession(configuration:URLSessionConfiguration.default)
    private let baseUrl = "https://reqres.in/api"
    
    func fetch<T: Decodable>(url: String) -> Observable<T> {
        guard let url = URL(string: baseUrl + url) else {
            return Observable.error(NetworkError.badURL)
        }
        
        let request = URLRequest(url: url)
        return session.rx.data(request: request)
            .map { data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode(T.self, from: data)
            }
    }
}
