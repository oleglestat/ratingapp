//
//  WNEfficiencyAPI.swift
//  WN8
//
//  Created by Oleg Chmut on 5/25/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import Foundation

// http://www.wnefficiency.net/exp/expected_tank_values_30.json
// No API Key needed

enum wnApiError: Error {
	case invalidJSONData
}

struct WNEfficiencyAPI {
	private static let baseURLString = "http://www.wnefficiency.net"
//  private static let baseURLString = "http://wottactic.com"
	
	static func wnURL() -> URL {
		var components = URLComponents(string: baseURLString)!
		components.path = "/exp/expected_tank_values_latest.json"
//    components.path = "/expected_v32.json"
		return components.url!
	}
	
	static func expTankValues(fromJSON data: Data) -> ExpTankValues {
		do {
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
			guard
				let jsonDictionary = jsonObject as? [AnyHashable:Any],
				let tanksArray = jsonDictionary["data"] as? [[String:Any]] else {
					// The JSON structure doesn't match our expectations
					return .failure(wnApiError.invalidJSONData)
			}
			var expectedValues = [expTank]()
			for tankJSON in tanksArray {
				if let tank = tank(fromJSON: tankJSON) {
					expectedValues.append(tank)
				}
			}
			if expectedValues.isEmpty && !tanksArray.isEmpty {
				return .failure(wnApiError.invalidJSONData)
			}
			return .success(expectedValues)
		} catch let error {
			return .failure(error)
		}
	}
	
	private static func tank(fromJSON json: [AnyHashable:Any]) -> expTank? {
		guard
			let tankID = json["IDNum"] as? Int,
			let expFrag = json["expFrag"] as? Double,
			let expDamage = json["expDamage"] as? Double,
			let expSpot = json["expSpot"] as? Double,
			let expDef = json["expDef"] as? Double,
			let expWinRate = json["expWinRate"] as? Double else {
				return nil
		}
		return expTank(tankID: tankID, frags: expFrag, damage: expDamage, spot: expSpot, def: expDef, winRate: expWinRate)
	}
}
