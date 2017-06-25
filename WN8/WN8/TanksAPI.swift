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
  case vehicleDetail = "/wotx/encyclopedia/vehicles/" // ?application_id=demo&tank_id=7441%2C257%2C353
}

// struct will be responsible for knowing and handling all Wargaming-related information. This includes knowing how to generate the URLs that the Wargaming API expects as well as knowing the format of the incoming JSON and how to parse that JSON into the relevant model objects.
struct TanksAPI {
	// static - A type-level property (or method) is one that is accessed on the type itself
	// private - visible only in enclosing scope
	private static let baseURLString = "https://api-ps4-console.worldoftanks.com"
	private static let apiKey = "5b059db003a2fef6bc7b24967de9e50e"
	
	// MARK: - method for building urld for request. Wont be visible to rest of the project
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
  
	// MARK: - getting players list methods
	// requesting account_id by name
	static func playersURL(name: String) -> URL {
		return wotURL(method: .players, parameters: ["search": name])
	}
  
  // method to parse JSON and return array of players from api
  static func players(fromJSON data: Data) -> PlayersResults {
    do {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      guard
        let jsonDictionary = jsonObject as? [AnyHashable:Any],
        let playersArray = jsonDictionary["data"] as? [[String:Any]] else {
          // The JSON structure doesn't match our expectations
          return .failure(apiError.invalidJSONData)
      }
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
  
  // MARK: - getting player details
  // requesting player data by account_id
  static func playerDetailsURL(playerID: String) -> URL {
    return wotURL(method: .playerPersonalData, parameters: ["account_id": playerID])
  }
  
  // method to parse json and return player details
  static func player(fromJSON data: Data, player: Player) -> PlayerResults {
    do {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      guard
        let jsonDictionary = jsonObject as? [AnyHashable:Any],
        let data = jsonDictionary["data"] as? [String:Any],
        let playerJson = data["\(player.playerID)"] as? [String:Any] else {
          return .failure(apiError.invalidJSONData)
      }
      if let player = playerDetail(fromJSON: playerJson, player: player) {
        return .success(player)
      }
      return .failure(apiError.invalidJSONData)
    } catch let error {
      return .failure(error)
    }
  }
	
  // method to create Player object
  private static func playerDetail(fromJSON json: [AnyHashable:Any], player: Player) -> Player? {
    guard
      let created = json["created_at"] as? Int,
      let updated = json["updated_at"] as? Int,
      let globalRating = json["global_rating"] as? Int,
      let lastBattleTime = json["last_battle_time"] as? Int,
      let statistics = json["statistics"] as? [String:Any],
      let statisticsMaxFragsTankID = statistics["max_frags_tank_id"] as? Int,
      let statisticsExplosionHits = statistics["explosion_hits"] as? Int,
      let statisticsMaxXpTankID = statistics["max_xp_tank_id"] as? Int,
      let statisticsDamageAssistedTrack = statistics["damage_assisted_track"] as? Int,
      let statisticsMaxXp = statistics["max_xp"] as? Int,
      let statisticsPiercings = statistics["piercings"] as? Int,
      let statisticsTreesCut = statistics["trees_cut"] as? Int,
      let statisticsPiercingsReceived = statistics["piercings_received"] as? Int,
      let statisticsNoDamageDirectHitsReceived = statistics["no_damage_direct_hits_received"] as? Int,
      let statisticsMaxFrags = statistics["max_frags"] as? Int,
      let statisticsExplosionHitsReceived = statistics["explosion_hits_received"] as? Int,
      let statisticsMaxDamageTankID = statistics["max_damage_tank_id"] as? Int,
      let statisticsDirectHitsReceived = statistics["direct_hits_received"] as? Int,
      let statisticsMaxDamage = statistics["max_damage"] as? Int,
      let statisticsDamageAssistedRadio = statistics["damage_assisted_radio"] as? Int,
      let statisticsAll = statistics["all"] as? [String:Any],
      let statisticsAllSpotted = statisticsAll["spotted"] as? Int,
      let statisticsAllHits = statisticsAll["hits"] as? Int,
      let statisticsAllWins = statisticsAll["wins"] as? Int,
      let statisticsAllLosses = statisticsAll["losses"] as? Int,
      let statisticsAllCapturePoints = statisticsAll["capture_points"] as? Int,
      let statisticsAllBattles = statisticsAll["battles"] as? Int,
      let statisticsAllDamageDealt = statisticsAll["damage_dealt"] as? Int,
      let statisticsAllDamageReceived = statisticsAll["damage_received"] as? Int,
      let statisticsAllShots = statisticsAll["shots"] as? Int,
      let statisticsAllXp = statisticsAll["xp"] as? Int,
      let statisticsAllFrags = statisticsAll["frags"] as? Int,
      let statisticsAllSurvivedBattles = statisticsAll["survived_battles"] as? Int,
      let statisticsAllDroppedCapturePoints = statisticsAll["dropped_capture_points"] as? Int
    else {
      return nil
    }
    let statAll = All(spotted: statisticsAllSpotted,
                            hits: statisticsAllHits,
                            wins: statisticsAllWins,
                            losses: statisticsAllLosses,
                            capturePoints: statisticsAllCapturePoints,
                            battles: statisticsAllBattles,
                            damageDealt: statisticsAllDamageDealt,
                            damageReceived: statisticsAllDamageReceived,
                            shots: statisticsAllShots,
                            xp: statisticsAllXp,
                            frags: statisticsAllFrags,
                            survivedBattles: statisticsAllSurvivedBattles,
                            droppedCapturePoints: statisticsAllDroppedCapturePoints)
    let stat = Statistics(maxFragsTankID: statisticsMaxFragsTankID,
                                explosionHits: statisticsExplosionHits,
                                maxXpTankID: statisticsMaxXpTankID,
                                damageAssistedTrack: statisticsDamageAssistedTrack,
                                maxXp: statisticsMaxXp,
                                piercings: statisticsPiercings,
                                treesCut: statisticsTreesCut,
                                piercingsReceived: statisticsPiercingsReceived,
                                noDamageDirectHitsReceived: statisticsNoDamageDirectHitsReceived,
                                maxFrags: statisticsMaxFrags,
                                explosionHitsReceived: statisticsExplosionHitsReceived,
                                maxDamageTankID: statisticsMaxDamageTankID,
                                directHitsReceived: statisticsDirectHitsReceived,
                                maxDamage: statisticsMaxDamage,
                                damageAssistedRadio: statisticsDamageAssistedRadio,
                                all: statAll,
                                company: nil)
    player.created = created
    player.updated = updated
    player.globalRating = globalRating
    player.lastBattleTime = lastBattleTime
    player.statistics = stat
    return player
  }
  
  // MARK: - getting tanks of player
	// requesting tanks data by account_id
	static func playerVehicleURL(playerID: String) -> URL {
		return wotURL(method: .playerVehicleData, parameters: ["account_id": playerID])
	}
	
	// method to parse JSON and return array of tanks from api
	static func vehicles(fromJSON data: Data, player: Player) -> PlayerVehicle {
		do {
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
			guard
				let jsonDictionary = jsonObject as? [AnyHashable:Any],
				let data = jsonDictionary["data"] as? [String:Any],
				let vehiclesArray = data["\(player.playerID)"] as? [[String:Any]] else {
					// The JSON structure doesn't match our expectations
					return .failure(apiError.invalidJSONData)
			}
			var finalVehicles = [Tank]()
			for tankJSON in vehiclesArray {
				if let tank = tank(fromJSON: tankJSON) {
					finalVehicles.append(tank)
				}
			}
			if finalVehicles.isEmpty && !vehiclesArray.isEmpty {
				// we weren't able to parse any of the players
				// Maybe the JSON format for players has changed
				return .failure(apiError.invalidJSONData)
			}
			return .success(finalVehicles)
		} catch let error {
			return .failure(error)
		}
	}
	
	// method to created Tank object
	private static func tank(fromJSON json: [AnyHashable:Any]) -> Tank? {
		guard
			let accountID = json["account_id"] as? Int,
			let battleLifeTime = json["battle_life_time"] as? Int,
			let lastBattleTime = json["last_battle_time"] as? Int,
			let markOfMastery = json["mark_of_mastery"] as? Int,
			let maxFrags = json["max_frags"] as? Int,
			let maxXP = json["max_xp"] as? Int,
			let tankID = json["tank_id"] as? Int,
			let treesCut = json["trees_cut"] as? Int,
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
		let allTemp = AllTank(spotted: allSpotted,
		                      piercingsReceived: allPiercingsReceived,
		                      hits: allHits,
		                      damageAssistedTrack: allDamageAssistedTrack,
		                      wins: allWins,
		                      losses: allLosses,
		                      noDamageDirectHitsReceived: allNoDamageDirectHitsReceived,
		                      capturePoints: allCapturePoints,
		                      battles: allBattles,
		                      damageDealt: allDamageDealt,
		                      explosionHits: allExplosionHits,
		                      damageReceived: allDamageReceived,
		                      piercings: allPiercings,
		                      shots: allShots,
		                      explosionHitsReceived: allExplosionHitsReceived,
		                      damageAssistedRadio: allDamageAssistedRadio,
		                      xp: allXp,
		                      directHitsReceived: allDirectHitsReceived,
		                      frags: allFrags,
		                      survivedBattles: allSurvivedBattles,
		                      droppedCapturePoints: allDroppedCapturePoints)
		let companyTemp = CompanyTank(spotted: companySpotted,
		                              piercingsReceived: companyPiercingsReceived,
		                              hits: companyHits,
		                              damageAssistedTrack: companyDamageAssistedTrack,
		                              wins: companyWins,
		                              losses: companyLosses,
		                              noDamageDirectHitsReceived: companyNoDamageDirectHitsReceived,
		                              capturePoints: companyCapturePoints,
		                              battles: companyBattles,
		                              damageDealt: companyDamageDealt,
		                              explosionHits: companyExplosionHits,
		                              damageReceived: companyDamageReceived,
		                              piercings: companyPiercings,
		                              shots: companyShots,
		                              explosionHitsReceived: companyExplosionHitsReceived,
		                              damageAssistedRadio: companyDamageAssistedRadio,
		                              xp: companyXp,
		                              directHitsReceived: companyDirectHitsReceived,
		                              frags: companyFrags,
		                              survivedBattles: companySurvivedBattles,
		                              droppedCapturePoints: companyDroppedCapturePoints)
		return Tank(tankID: tankID,
		            name: nil,
		            nation: nil,
		            type: nil,
		            tier: nil,
		            battleLifeTime: battleLifeTime,
		            markOfMastery: markOfMastery,
		            maxFrags: maxFrags,
		            treesCut: treesCut,
		            maxXp: maxXP,
		            accountID: accountID,
		            lastBattleTime: lastBattleTime,
		            all: allTemp,
		            company: companyTemp)
	}
  
  // MARK: - getting vehicle details
  static func vehicleDetailURL(tanksListID: String) -> URL {
    return wotURL(method: .vehicleDetail, parameters: ["tank_id": tanksListID])
  }
  
  
}

