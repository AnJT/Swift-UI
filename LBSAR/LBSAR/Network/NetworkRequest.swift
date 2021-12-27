//
//  NetworkRequest.swift
//  LBSAR
//
//  Created by ajt on 2021/12/16.
//

import Foundation

struct NetworkRequest {
        
    static func request<T: Decodable>(_ route: Router, completion: @escaping (Result<T, Error>) -> () ) {
            let request =  route.asURLRequest()
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {return}

                do {
                    let pointofInterest = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(pointofInterest))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }

            dataTask.resume()
        }
}
