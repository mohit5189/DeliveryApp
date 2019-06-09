//
//  URLBuilder.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

class URLBuilder: NSObject {
    var baseUrl: String
    var endPoint: String
    var finalUrl: String
    let questionMark = "?"
    let queryParamSeperater = "&"

    init(baseUrl: String, endPoint: String) {
        self.baseUrl = baseUrl
        self.endPoint = endPoint
        self.finalUrl = baseUrl + endPoint + questionMark
    }
    
    func addQueryParameter(paramKey: String, value: String) {
        finalUrl += String(format: "%@=%@%@", paramKey, value, queryParamSeperater)
    }
    
    func getFinalUrl() -> String {
        return String(finalUrl.dropLast())
    }
    
}
