//
//  WarGamingAPI.swift
//  WN8
//
//  Created by Oleg Chmut on 5/18/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import Foundation


/*https:/api-ps4-console.worldoftanks.com/wotx/account/list/?application_id=5b059db003a2fef6bc7b24967de9e50e&search=Royal

https:/api-ps4-console.worldoftanks.com/wotx/account/info/?application_id=5b059db003a2fef6bc7b24967de9e50e&account_id=1075965563

https:/api-ps4-console.worldoftanks.com/wotx/clans/list/?application_id=5b059db003a2fef6bc7b24967de9e50e&search=UP

https:/api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=a6d819499131071f158fd740860a5a88&extras=url_h,date_taken&format=json&nojsoncallback=1

*/

enum apiError: Error {
	case invalidJSONData
}

// using enumeration for easy managment of API endpoint
enum Method: String {
	case players = "/wotx/account/list/"
	case playerPersonalData = "/wotx/account/info/"
	case playerVehicleData = "/wotx/tanks/stats/"
}

// struct will be responsible for knowing and handling all Wargaming-related information. This includes knowing how to generate the URLs that the Wargaming API expects as well as knowing the format of the incoming JSON and how to parse that JSON into the relevant model objects.
struct TanksAPI {
	// static - A type-level property (or method) is one that is accessed on the type itself
	// private - visible only in enclosing scope
	private static let baseURLString = "https://api-ps4-console.worldoftanks.com"
	private static let apiKey = "5b059db003a2fef6bc7b24967de9e50e"
	
	// method for building urld for request. Wont be visible to rest of the project
	private static func wotURL(method: Method, parameters: [String:String]?) -> URL {
		var components = URLComponents(string: baseURLString)!
		components.path = method.rawValue
		var queryItems = [URLQueryItem]()
		queryItems.append(URLQueryItem(name: "application_id", value: apiKey))
		
		if let additionalParams = parameters {
			for (key, value) in additionalParams {
				let item = URLQueryItem(name: key, value: value)
				queryItems.append(item)
			}
		}
		components.queryItems = queryItems
		
		return components.url!
	}
	
	// requesting account_id by name
	static func playersURL(name: String) -> URL {
		return wotURL(method: .players, parameters: ["search": name])
	}
	
	// requesting tanks data by account_id
	static func playerVehicleURL(id: String) -> URL {
		return wotURL(method: .playerVehicleData, parameters: ["account_id": id])
	}
		
	
	// method to parse JSON and return array of players from api
	static func players(fromJSON data: Data) -> PlayersResults {
		do {
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
			
			//print(jsonObject)
			
			guard
				let jsonDictionary = jsonObject as? [AnyHashable:Any],
				let playersArray = jsonDictionary["data"] as? [[String:Any]] else {
					// The JSON structure doesn't match our expectations
					return .failure(apiError.invalidJSONData)
			}
			
			//print(playersArray)
			
			var finalPlayers = [Player]()
			
			for playerJSON in playersArray {
				if let player = player(fromJSON: playerJSON) {
					finalPlayers.append(player)
				}
			}
			
			if finalPlayers.isEmpty && !playersArray.isEmpty {
				// we weren't able to parse any of the players
				// Maybe the JSON format for players has changed
				return .failure(apiError.invalidJSONData)
			}
			return .success(finalPlayers)
		} catch let error {
			return .failure(error)
		}
	}
	
	// method to created Player object
	private static func player(fromJSON json: [AnyHashable:Any]) -> Player? {
		guard
			let playerID = json["account_id"] as? Int,
			let nickname = json["nickname"] as? String else {
				// Don't have enought information to construct a Player
				return nil
		}
		return Player(nickname: nickname, playerID: playerID)
	}
}

