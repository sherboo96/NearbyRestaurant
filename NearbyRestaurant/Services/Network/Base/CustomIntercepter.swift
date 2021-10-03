//
//  CustomIntercepter.swift
//  Network
//
//  Created by Mahmoud Sherbeny on 30/08/2021.
//

import Foundation
import Alamofire

class CustomIntercepter: RequestInterceptor {
    
    var retryCount = 0
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let statusCode = request.response?.statusCode, statusCode != 200 && self.retryCount < 3 {
            self.retryCount += 1
            completion(.retryWithDelay(5))
        } else {
            completion(.doNotRetry)
        }
    }
}
