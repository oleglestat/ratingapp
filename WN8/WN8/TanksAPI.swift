//
//  WarGamingAPI.swift
//  WN8
//
//  Created by Oleg Chmut on 5/18/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import Foundation

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
	static func playerVehicleURL(playerID: String) -> URL {
		return wotURL(method: .playerVehicleData, parameters: ["account_id": playerID])
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
	
	static func vehicles(fromJSON data: Data) -> PlayerVehicle {
		do {
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
			guard
			let jsonDictionary = jsonObject as? [AnyHashable:Any],
				let vehiclesArray = jsonDictionary["data"] as? [[String:Any]] else {
					// The JSON structure doesn't match our expectations
					return .failure(apiError.invalidJSONData)
			}
			// TODO: WTF with .self?
			var finalVehicles = [Player.Tank.self]
			
			for tankJSON in vehiclesArray {
				if let tank = tank(fromJSON: tankJSON) {
					finalVehicles.append(tank)
				}
			}
		} catch let error {
			return .failure(error)
		}
	}
	
	// method to create Player object
	private static func player(fromJSON json: [AnyHashable:Any]) -> Player? {
		guard
			let playerID = json["account_id"] as? Int,
			let nickname = json["nickname"] as? String else {
				// Don't have enought information to construct a Player
				return nil
		}
		return Player(nickname: nickname, playerID: playerID)
	}
	
	// method to created Tank object
	private static func tank(fromJSON json: [AnyHashable:Any]) -> Player.Tank? {
		guard
			let accountID = json["account_id"] as? Int,
			let battleLifeTime = json["battle_life_time"] as? Int,
			let inGarageUpdated = json["in_garage_updated"] as? Int,
			let lastBattleTime = json["last_battle_time"] as? Int,
			let markOfMastery = json["mark_of_mastery"] as? Int,
			let maxFrags = json["max_frags"] as? Int,
			let maxXP = json["max_xp"] as? Int,
			let tankID = json["tank_id"] as? Int,
			let treesCut = json["trees_cut"] as? Int,
			let frags = json["frags"] as? [Int],
			let inGarage = json["in_garage"] as? Bool,
			let all = json["all"] as? [String:Any],
			let allBattles = all["battles"] as? Int,
			let allCapturePoints = all["capture_points"] as? Int,
			let allDamageAssistedRadio = all["damage_assisted_radio"] as? Int,
			let allDamageAssistedTrack = all["damage_assisted_track"] as? Int,
			let allDamageDealt = all["damage_dealt"] as? Int,
			let allDamageReceived = all["damage_received"] as? Int,
			let allDirectHitsReceived = all["direct_hits_received"] as? Int,
			let allDroppedCapturePoints = all["dropped_capture_points"] as? Int,
			let allExplosionHits = all["explosion_hits"] as? Int,
			let allExplosionHitsReceived = all["explosion_hits_received"] as? Int,
			let allFrags = all["frags"] as? Int,
			let allHits = all["hits"] as? Int,
			let allLosses = all["losses"] as? Int,
			let allNoDamageDirectHitsReceived = all["no_damage_direct_hits_received"] as? Int,
			let allPiercings = all["piercings"] as? Int,
			let allPiercingsReceived = all["piercings_received"] as? Int,
			let allShots = all["shots"] as? Int,
			let allSpotted = all["spotted"] as? Int,
			let allSurvivedBattles = all["survived_battles"] as? Int,
			let allWins = all["wins"] as? Int,
			let allXp = all["xp"] as? Int,
			let company = json["company"] as? [String:Any],
			let companyBattles = company["battles"] as? Int,
			let companyCapturePoints = company["capture_points"] as? Int,
			let companyDamageAssistedRadio = company["damage_assisted_radio"] as? Int,
			let companyDamageAssistedTrack = company["damage_assisted_track"] as? Int,
			let companyDamageDealt = company["damage_dealt"] as? Int,
			let companyDamageReceived = company["damage_received"] as? Int,
			let companyDirectHitsReceived = company["direct_hits_received"] as? Int,
			let companyDroppedCapturePoints = company["dropped_capture_points"] as? Int,
			let companyExplosionHits = company["explosion_hits"] as? Int,
			let companyExplosionHitsReceived = company["explosion_hits_received"] as? Int,
			let companyFrags = company["frags"] as? Int,
			let companyHits = company["hits"] as? Int,
			let companyLosses = company["losses"] as? Int,
			let companyNoDamageDirectHitsReceived = company["no_damage_direct_hits_received"] as? Int,
			let companyPiercings = company["piercings"] as? Int,
			let companyPiercingsReceived = company["piercings_received"] as? Int,
			let companyShots = company["shots"] as? Int,
			let companySpotted = company["spotted"] as? Int,
			let companySurvivedBattles = company["survived_battles"] as? Int,
			let companyWins = company["wins"] as? Int,
			let companyXp = company["xp"] as? Int
		else {
			// Don't have enought information to construct a Player
			return nil
		}
		return 
	}
}

