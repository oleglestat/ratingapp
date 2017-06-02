//
//  Player.swift
//  WN8
//
//  Created by Oleg Chmut on 5/19/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import Foundation

class Player {
	var nickname: String
	var playerID: Int
	var created: Int?
	var updated: Int?
	var privateInfo: Int?
	var globalRating: Int?
	var lastBattleTime: Int?
	var statistics: Statistics?
	var tanks: [Tank]?
	init(nickname: String, playerID: Int) {
		self.nickname = nickname
		self.playerID = playerID
	}
}

struct Statistics {
	var maxFragsTankID: Int?
	var explosionHits: Int?
	var maxXpTankID: Int?
	var damageAssistedTrack: Int?
	var maxXp: Int?
	var piercings: Int?
	var treesCut: Int?
	var piercingsReceived: Int?
	var noDamageDirectHitsReceived: Int?
	var maxFrags: Int?
	var explosionHitsReceived: Int?
	var maxDamageTankID: Int?
	var frags: Int?
	var directHitsReceived: Int?
	var maxDamage: Int?
	var damageAssistedRadio: Int?
	var all: All?
	var company: Company?
}

struct All {
	var spotted: Int?
	var hits: Int?
	var wins: Int?
	var losses: Int?
	var capturePoints: Int?
	var battles: Int?
	var damageDealt: Int?
	var damageReceived: Int?
	var shots: Int?
	var xp: Int?
	var frags: Int?
	var survivedBattles: Int?
	var droppedCapturePoints: Int?
}

struct Company {
	var spotted: Int?
	var hits: Int?
	var wins: Int?
	var losses: Int?
	var capturePoints: Int?
	var battles: Int?
	var damageDealt: Int?
	var damageReceived: Int?
	var shots: Int?
	var xp: Int?
	var frags: Int?
	var survivedBattles: Int?
	var droppedCapturePoints: Int?
}

struct Tank {
	let tankID: Int?
	var battleLifeTime: Int?
	var markOfMastery: Int?
	var maxFrags: Int?
	var treesCut: Int?
	var maxXp: Int?
	var accountID: Int?
	var lastBattleTime: Int?
	var all: AllTank?
	var company: CompanyTank?
//	Variables that need authentication on wargaming servers to be not <null>
//	var inGarageUpdated: Int?
//	var frags: [Int]?
//	var inGarage: Bool?
}

struct AllTank {
	var spotted: Int?
	var piercingsReceived: Int?
	var hits: Int?
	var damageAssistedTrack: Int?
	var wins: Int?
	var losses: Int?
	var noDamageDirectHitsReceived: Int?
	var capturePoints: Int?
	var battles: Int?
	var damageDealt: Int?
	var explosionHits: Int?
	var damageReceived: Int?
	var piercings: Int?
	var shots: Int?
	var explosionHitsReceived: Int?
	var damageAssistedRadio: Int?
	var xp: Int?
	var directHitsReceived: Int?
	var frags: Int?
	var survivedBattles: Int?
	var droppedCapturePoints: Int?
}

struct CompanyTank {
	var spotted: Int?
	var piercingsReceived: Int?
	var hits: Int?
	var damageAssistedTrack: Int?
	var wins: Int?
	var losses: Int?
	var noDamageDirectHitsReceived: Int?
	var capturePoints: Int?
	var battles: Int?
	var damageDealt: Int?
	var explosionHits: Int?
	var damageReceived: Int?
	var piercings: Int?
	var shots: Int?
	var explosionHitsReceived: Int?
	var damageAssistedRadio: Int?
	var xp: Int?
	var directHitsReceived: Int?
	var frags: Int?
	var survivedBattles: Int?
	var droppedCapturePoints: Int?
}
