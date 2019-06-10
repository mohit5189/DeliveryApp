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
    struct DeliveryListScreen {
        static let deliveryListScreenTitle = NSLocalizedString("deliveryListTitle", comment: "")
    }
    struct ErrorMessage {
        static let genericErrorMessage = NSLocalizedString("networkErrorMessage", comment: "")
        static let errorTitle = NSLocalizedString("networkErrorTitle", comment: "")
        static let internetErrorMessage = NSLocalizedString("internetErrorMessage", comment: "")
    }
    struct MapScreen {
        static let mapScreenTitle = NSLocalizedString("mapScreenTitle", comment: "")
        static let currentLocationTitle = NSLocalizedString("currentLocationTitle", comment: "")
    }
    struct CommonStrings {
        static let okButtonTitle = NSLocalizedString("okButtonTitle", comment: "")
    }
}
