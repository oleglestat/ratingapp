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
	var expValues: [expTank]!
	
  @IBOutlet weak var testLabel: UILabel!
  
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
    store.fetchVehicleDataOf(player) {
			(vehicleResults) -> Void in
			switch vehicleResults {
			case let .success(vehicles):
				self.player.tanks = vehicles
				print("\(self.player.nickname) got \(vehicles.count) tanks")
        self.calculateAccountWN8(player: self.player, exp: self.expValues)
			case let .failure(error):
				print("Error fetching players: \(error)")
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = player.nickname
	}
  
  func calculateAccountWN8(player: Player, exp: [expTank]) {
    let expectedTotals = (expDamage: 0, expSpot: 0, expFrag: 0, expDef: 0, expWinRate: 0)
    let achivedTotals = (damageDealth: 0, spotted: 0, frags: 0, droppedCapturePoints: 0, wins: 0, battles: 0)
    
    if let tanks = player.tanks {
      for tank in tanks {
        print(tank)
      }
    }
    
    return
  }

}
