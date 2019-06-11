//
//  HTTPClient.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

enum ApiType:String{
    case GET = "GET"
}

class HTTPClient: HTTPClientProtocol {
    var url: String
    var requestJson: [String:String]?
    var session = URLSession.shared
    
    init(url: String, requestJson: [String:String] = [:]) {
        self.url = url
        self.requestJson = requestJson
    }
    
    func sendRequest(completionHandler: @escaping CompletionBlock) {
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.networkTimeoutInterval)
        request.httpMethod = ApiType.GET.rawValue
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            completionHandler(data, error)
        })
        
        task.resume()
    }
}
