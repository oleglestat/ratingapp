//
//  ExpectedTankValues.swift
//  WN8
//
//  Created by Oleg Chmut on 5/22/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//


// Class to represent expected values for each tank.
// http://www.wnefficiency.net/exp/expected_tank_values_30.json
import Foundation

class expTank {
	let tankID: Int
	let expFrag: Int
	let expDamage: Int
	let expSpot: Int
	let expDef: Int
	let expWinRate: Int
	init(tankID: Int, frags: Int, damage: Int, spot: Int, def: Int, winRate: Int) {
		self.tankID = tankID
		expFrag = frags
		expDamage = damage
		expSpot = spot
		expDef = def
		expWinRate = winRate
	}
}
