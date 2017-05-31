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
	struct statistics {
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
		struct all {
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
		struct company {
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
	}
	var tanks: [Tank]?
	
	init(nickname: String, playerID: Int) {
		self.nickname = nickname
		self.playerID = playerID
	}
	
	var description: String {
		return ("\(nickname)  \(playerID)")
	}
	
	struct Tank {
		let tankID: Int?
		var inGarage: Bool?
		var battleLifeTime: Int?
		var markOfMastery: Int?
		var frags: [Int]?
		var maxFrags: Int?
		var inGarageUpdated: Int?
		var treesCut: Int?
		var maxXp: Int?
		var accountID: Int?
		var lastBattleTime: Int?
		struct all {
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
		struct company {
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
		init(tankID: Int, inGarage: Bool, battleLifeTime: Int, markOfMastery: Int, frags: [Int], maxFrags: Int, inGarageUpdated: Int, treesCut: Int, maxXp: Int, accountID: Int, lastBattleTime: Int, allSpotted: Int) {
			self.tankID = tankID
			self.accountID = accountID
			self.inGarageUpdated = inGarageUpdated
			self.lastBattleTime = lastBattleTime
			self.markOfMastery = markOfMastery
			self.maxFrags = maxFrags
			self.maxXp = maxXp
			self.tankID = tankID
			self.treesCut = treesCut
			self.frags = frags
			self.inGarage = inGarage
			
		}
		// TODO: узнать блять как этот ебаный ТАНК, в особености ебаные нестед структуры. Может нахуй нестед структуры? заменить их словарем или массивом. ну или блять сделать отдельные струтуры, и просто обьявить их как переменную внутры другой
	}
	
}
