//
//  NetworkService.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

import RxSwift

enum NetError: Error {
    case badURL
    case unknown
}

protocol NetworkServiceProtocol {
    var baseUrl: String { get }
    func fetch<T: Decodable>(url: String) -> Observable<T>
}

public class NetworkService: NetworkServiceProtocol {
    let session = URLSession(configuration:URLSessionConfiguration.default)
    let baseUrl = "https://reqres.in/api"
    
    func fetch<T: Decodable>(url: String) -> Observable<T> {
        guard let url = URL(string: url) else {
            return Observable.error(NetError.badURL)
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
