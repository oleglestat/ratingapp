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
  var calculator: Calculator!
	
  @IBOutlet weak var testLabel: UILabel!
  @IBOutlet weak var personalRationg: UILabel!
  @IBOutlet weak var winRate: UILabel!
  @IBOutlet weak var battles: UILabel!
  @IBOutlet weak var averageDamage: UILabel!
  @IBOutlet weak var killDeathRatio: UILabel!
  
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
    concurentFetch()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = player.nickname
	}
  
  // MARK: - making calls asynchronously
  func concurentFetch() {
    DispatchQueue.global().async {
      self.store.fetchVehicleDataOf(self.player) {
        (vehicleResults) -> Void in
        switch vehicleResults {
        case let .success(vehicles):
          self.player.tanks = vehicles
          print("\(self.player.nickname) got \(vehicles.count) tanks")
          self.testLabel.text = String(describing: self.calculator.calculateAccountWN8(player: self.player, exp: self.expValues))
        case let .failure(error):
          print("Error fetching player tanks: \(error)")
        }
      }
    }
    DispatchQueue.global().async {
      self.store.fetchDetailsOf(self.player) {
        (playerDetail) -> Void in
        switch playerDetail {
        case let .success(player):
          self.player = player
          guard let wins = self.player.statistics?.all?.wins,
            let battles = self.player.statistics?.all?.battles,
            let damageDealt = self.player.statistics?.all?.damageDealt,
            let frags = self.player.statistics?.all?.frags,
            let survived = self.player.statistics?.all?.survivedBattles,
            let personalRating = self.player.globalRating
            else {
              return
          }
          self.winRate.text = String(format: "%.2f", Double(wins) / Double(battles) * 100)
          self.personalRationg.text = String(describing: personalRating)
          self.battles.text = String(describing: battles)
          self.averageDamage.text = String(format: "%.2f", Double(damageDealt) / Double(battles))
          self.killDeathRatio.text = String(format: "%.2f", Double(frags) / (Double(battles) - Double(survived)))
        case let .failure(error):
          print("Error fetching player: \(error)")
        }
      }
    }
  }
}
