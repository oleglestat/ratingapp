//
//  RequestViewController.swift
//  WN8
//
//  Created by Oleg Chmut on 5/12/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {
	
	@IBOutlet weak var searchField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	
	// property injection, see AppDelegate
	var store: DataStore!
  var calculator: Calculator!
	var playersFound: [Player] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var expValues: [expTank]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Remove the title of the back button
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		// Remove empty cells with slitter in tableview
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		store.fetchExpectedValuesData {
			(expectedValues) -> Void in
			
			switch expectedValues {
			case let .success(values):
				self.expValues = values
			case let .failure(error):
				print("Error fetching players: \(error)")
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PlayerDetail" {
			if let indexPath = tableView.indexPathForSelectedRow {
				let controller = segue.destination as! PlayerDetailsViewController
				controller.store = self.store
        controller.calculator = self.calculator
				controller.player = self.playersFound[indexPath.row]
				if let value = self.expValues {
					controller.expValues = value
				}
			}
		}
	}
}

// MARK: - handling search field interactions
extension RequestViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		searchForPlayer(textField)
		return true
	}
	
	func searchForPlayer(_ textField: UITextField) {
		if let nickname = textField.text, !nickname.isEmpty {
			store.fetchPlayersData(name: nickname) {
				(playerResult) -> Void in
				
				switch playerResult {
				case let .success(players):
					self.playersFound = players
				case let .failure(error):
					print("Error fetching players: \(error)")
				}
			}
		}
	}
}

// MARK: - Data source for table
extension RequestViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return playersFound.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let player = playersFound[indexPath.row]
		cell.textLabel?.text = player.nickname
		return cell
	}
}
