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
	let expFrag: Double
	let expDamage: Double
	let expSpot: Double
	let expDef: Double
	let expWinRate: Double
	init(tankID: Int, frags: Double, damage: Double, spot: Double, def: Double, winRate: Double) {
		self.tankID = tankID
		expFrag = frags
		expDamage = damage
		expSpot = spot
		expDef = def
		expWinRate = winRate
	}
}
