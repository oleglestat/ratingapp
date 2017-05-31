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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = player.nickname
		//store.fetchPlayerVehicleData()
	}

}
