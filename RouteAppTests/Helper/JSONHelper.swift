//
//  JSONHelper.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import Foundation
@testable import RouteApp

class JSONHelper {
    class func jsonFileToDict(jsonName: String) -> [String: AnyObject]? {
        if let path = Bundle.main.path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: AnyObject] {
                    return jsonResult
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    class func jsonFileToData(jsonName: String) -> Data? {
        if let path = Bundle.main.path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }

    class func getDeliveries() -> [DeliveryModel] {
        let data = jsonFileToData(jsonName: "deliveryList")
        do {
            let decoder = JSONDecoder()
            let deliveries = try decoder.decode([DeliveryModel].self, from: data!)
            return deliveries
        } catch {

        }
        return []
    }

}
