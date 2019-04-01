//
//  RequestExecutor.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation
import RxSwift

final class RequestExecutor {
    enum RequestExecutorError: Error {
        case invalidRequest
    }

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func executeRequest<ResultType: Decodable>(_ request: URLRequest?) -> Single<ResultType> {
        guard let request = request else { return .error(RequestExecutorError.invalidRequest) }

        return Single<ResultType>.create { [decoder] single -> Disposable in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                
                if let data = data {
                    do {
                        if 200..<300 ~= statusCode {
                            let result = try decoder.decode(ResultType.self, from: data)
                            single(.success(result))
                        } else {
                            let apiError = try decoder.decode(ApiErrorDto.self, from: data)
                            single(.error(NSError(apiError: apiError)))
                        }
                    } catch {
                        single(.error(error))
                    }
                } else if let error = error {
                    single(.error(error))
                }
            }
            task.resume()

            return Disposables.create(with: task.cancel)
        }
    }
}

extension NSError {
    convenience init(apiError: ApiErrorDto) {
        let userInfo = [NSLocalizedDescriptionKey: apiError.error, NSLocalizedFailureReasonErrorKey: apiError.message]
        self.init(domain: "api", code: apiError.statusCode, userInfo: userInfo)
    }
}
