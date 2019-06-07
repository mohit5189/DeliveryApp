//
//  Constants.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation

struct Constants {
    static let baseURL = "https://mock-api-mobile.dev.lalamove.com/"
    static let endPoint = "deliveries"
    static let networkTimeoutInterval: TimeInterval = 10
    static let serverErrorDomain = "HTTP Error"
    static let serverErrorCode = 500
    static let internetErrorCode = 523 // this is for origin unreachable
}

struct LocalizeStrings {
    static let genericErrorMessage = NSLocalizedString("networkErrorMessage", comment: "")
    static let errorTitle = NSLocalizedString("networkErrorTitle", comment: "")
    static let okButtonTitle = NSLocalizedString("okButtonTitle", comment: "")
    static let destinationListScreenTitle = NSLocalizedString("destinationListTitle", comment: "")
    static let mapScreenTitle = NSLocalizedString("mapScreenTitle", comment: "")
    static let internetErrorMessage = NSLocalizedString("internetErrorMessage", comment: "")
    static let currentLocationTitle = NSLocalizedString("currentLocationTitle", comment: "")
}
