//
//  dataStore.swift
//  WN8
//
//  Created by Oleg Chmut on 5/19/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import Foundation

enum PlayersResults {
	case success([Player])
	case failure(Error)
}

enum PlayerResults {
  case success(Player)
  case failure(Error)
}

enum ExpTankValues {
	case success([expTank])
	case failure(Error)
}

enum PlayerVehicle {
	case success([Tank])
	case failure(Error)
}

enum VehicleDetails {
  case success
  case failure(Error)
}

// class will handle the actual web service calls.
class DataStore {
	
	// session preset
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config)
	}()
	
	// MARK: - Requesting players
	
	// creating url and passing it to request object
	func fetchPlayersData(name: String, completion: @escaping (PlayersResults) -> Void) {
		let url = TanksAPI.playersURL(name: name)
		let request = URLRequest(url: url)
		let task = session.dataTask(with: request) {
			(data, response, error) -> Void in
			// parsing JSON data from server
			let result = self.processPlayersRequest(data: data, error: error)
			OperationQueue.main.addOperation {
				completion(result)
			}
		}
		task.resume()
	}
	
	private func processPlayersRequest(data: Data?, error: Error?) -> PlayersResults {
		guard let jsonData = data else {
			return .failure(error!)
		}
		return TanksAPI.players(fromJSON: jsonData)
	}
	
	// MARK: - Requesting players vehicles
	func fetchVehicleDataOf(_ player: Player, completion: @escaping (PlayerVehicle) -> Void) {
		let url = TanksAPI.playerVehicleURL(playerID: String(player.playerID))
		let request = URLRequest(url: url)
		let task = session.dataTask(with: request) {
			(data, response, error) -> Void in
			// parsing JSON data from server
			let result = self.processVehiclesRequest(data: data, player: player, error: error)
			OperationQueue.main.addOperation {
				completion(result)
			}
		}
		task.resume()
	}
	
	private func processVehiclesRequest(data: Data?, player: Player, error: Error?) -> PlayerVehicle {
		guard let jsonData = data else {
			return .failure(error!)
		}
		return TanksAPI.vehicles(fromJSON: jsonData, player: player)
	}
  
  // MARK: - Requesting player vehicle data
  func fetchVehicleDetailsOf(_ player: Player, completion: @escaping (VehicleDetails) -> Void) {
    var tankListID = ""
    if let tanks = player.tanks {
      for tank in tanks {
        tankListID.append(String(describing: tank.tankID!) + ",")
      }
    }
    let url = TanksAPI.vehicleDetailsURL(tanksListID: tankListID)
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) {
      (data, response, error) -> Void in
      let result = self.processVehiclesDetails(data: data, player: player, error: error)
      OperationQueue.main.addOperation {
        completion(result)
      }
    }
    task.resume()
  }
  
  private func processVehiclesDetails(data: Data?, player: Player, error: Error?) -> VehicleDetails {
    guard let jsonData = data else {
      return .failure(error!)
    }
    return TanksAPI.vehicleDetais(fromJSON: jsonData, player: player)
  }
  
  // MARK: - Requesting player details
  func fetchDetailsOf(_ player: Player, completion: @escaping (PlayerResults) -> Void) {
    let url = TanksAPI.playerDetailsURL(playerID: String(player.playerID))
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) {
      (data, response, error) -> Void in
      // parsing JSON data from server
      let result = self.processPlayerRequest(data: data, player: player, error: error)
      OperationQueue.main.addOperation {
        completion(result)
      }
    }
    task.resume()
  }
  
  private func processPlayerRequest(data: Data?, player: Player, error: Error?) -> PlayerResults {
    guard let jsonData = data else {
      return .failure(error!)
    }
    return TanksAPI.player(fromJSON: jsonData, player: player)
  }
	
	// MARK: - Requesting expected values	
	func fetchExpectedValuesData(completion: @escaping (ExpTankValues) -> Void) {
		let url = WNEfficiencyAPI.wnURL()
		let request = URLRequest(url: url)
		let task = session.dataTask(with: request) {
			(data, response, error) -> Void in
			// parsing JSON data from server
			let result = self.processExpectedValuesRequest(data: data, error: error)
			OperationQueue.main.addOperation {
				completion(result)
			}
		}
		task.resume()
	}
	
	private func processExpectedValuesRequest(data: Data?, error: Error?) -> ExpTankValues {
		guard let jsonData = data else {
			return .failure(error!)
		}
		return WNEfficiencyAPI.expTankValues(fromJSON: jsonData)
	}
}
