//
//  PlayerDetailsViewController.swift
//  WN8
//
//  Created by Oleg Chmut on 5/29/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UIViewController {
	
	var store: DataStore!
	var player: Player!
	var expValues: [expTank]?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
    store.fetchVehicleDataOf(player) {
			(vehicleResults) -> Void in
			switch vehicleResults {
			case let .success(vehicles):
				self.player.tanks = vehicles
				print("\(self.player.nickname) got \(vehicles.count) tanks")
			case let .failure(error):
				print("Error fetching players: \(error)")
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = player.nickname
	}

}
