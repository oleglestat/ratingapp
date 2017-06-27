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
  
  // TODO: высчитать потанковую статку и вывести ее в дитейл вьюв в таблицу, формулу тырить http://wottactic.com/wn8_standalone.html
	
  @IBOutlet weak var testLabel: UILabel!
  @IBOutlet weak var personalRationg: UILabel!
  @IBOutlet weak var winRate: UILabel!
  @IBOutlet weak var battles: UILabel!
  @IBOutlet weak var averageDamage: UILabel!
  @IBOutlet weak var killDeathRatio: UILabel!
  @IBOutlet weak var tanksTable: UITableView!
  
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
    concurentFetch()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = player.nickname
    tanksTable.rowHeight = 70
	}
  
  // MARK: - making calls asynchronously
  func concurentFetch() {
    DispatchQueue.global().sync {
      self.store.fetchVehicleDataOf(self.player) {
        (vehicleResults) -> Void in
        switch vehicleResults {
        case let .success(vehicles):
          print("Player tanks fetched")
          self.player.tanks = vehicles
          print("\(self.player.nickname) got \(vehicles.count) tanks")
          self.testLabel.text = String(describing: self.calculator.calculateAccountWN8(player: self.player, exp: self.expValues))
        case let .failure(error):
          print("Error fetching player tanks: \(error)")
        }
      }
      self.store.fetchVehicleDetailsOf(self.player) {
        (status) -> Void in
        switch status {
        case .success:
          print("Tank details fetched")
          self.tanksTable.reloadData()
        case let .failure(error):
          print("Error fetching tanks details: \(error)")
        }
      }
    }
    DispatchQueue.global().async {
      self.store.fetchDetailsOf(self.player) {
        (playerDetail) -> Void in
        switch playerDetail {
        case let .success(player):
          print("Player details fetched")
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
          self.winRate.text = String(format: "%.2f", Double(wins) / Double(battles) * 100) + " %"
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

extension PlayerDetailsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let numberOfTanks = player.tanks {
      return numberOfTanks.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TankCell", for: indexPath) as! TankCell
    let tank = player.tanks![indexPath.row]
    guard let wins = tank.all?.wins,
      let battles = tank.all?.battles,
      let damageDealt = tank.all?.damageDealt,
      let tier = tank.tier,
      let type = tank.type else {
        return cell
    }
    switch type {
    case "heavyTank":
      cell.tankClass.text = "Heavy Tank"
    case "mediumTank":
      cell.tankClass.text = "Medium Tank"
    case "lightTank":
      cell.tankClass.text = "Light Tank"
    case "AT-SPG":
      cell.tankClass.text = "Tank Destroyer"
    case "SPG":
      cell.tankClass.text = "Artillery"
    default:
      cell.tankClass.text = "Tank"
    }
    let rating = calculator.calculateTankWN8(tank: tank, exp: expValues) < 5 ? "--" : String(calculator.calculateTankWN8(tank: tank, exp: expValues))
    cell.tankName.text = tank.name
    cell.tier.text = String(describing: tier)
    cell.winRate.text = String(format: "%.2f", Double(wins) / Double(battles) * 100)  + " %"
    cell.rating.text = rating
    cell.avgDamage.text = String(format: "%.2f", Double(damageDealt) / Double(battles))
    return cell
  }
}
