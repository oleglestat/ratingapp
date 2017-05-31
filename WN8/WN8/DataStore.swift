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

enum ExpTankValues {
	case success([expTank])
	case failure(Error)
}

enum PlayerVehicle {
	case success([Tank])
	case failure(Error)
}

// class will handle the actual web service calls.
class DataStore {
	
	// session preset
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config)
	}()
	
	// Requesting players
	
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
	
	// Requesting players vehicles
	func fetchVehicleDataOf(_ player: Player, completion: @escaping (PlayerVehicle) -> Void) {
		let url = TanksAPI.playerVehicleURL(playerID: String(player.playerID))
		let request = URLRequest(url: url)
		let task = session.dataTask(with: request) {
			(data, response, error) -> Void in
			// parsing JSON data from server
			let result = self.processVehiclesRequest(data: data, error: error)
			OperationQueue.main.addOperation {
				completion(result)
			}
		}
		task.resume()
	}
	
	private func processVehiclesRequest(data: Data?, error: Error?) -> PlayerVehicle {
		guard let jsonData = data else {
			return .failure(error!)
		}
		return TanksAPI.vehicles(fromJSON: jsonData)
	}
	
	// Requesting expected values
	
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
