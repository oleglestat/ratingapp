//
//  Calculator.swift
//  WN8
//
//  Created by Oleg Chmut on 6/6/17.
//  Copyright © 2017 RoyalInn. All rights reserved.
//

import Foundation

struct Calculator {
  func calculateAccountWN8(player: Player, exp: [expTank]) -> Int {
    var expectedTotals = (expDamage: 0.0, expSpot: 0.0, expFrag: 0.0, expDef: 0.0, expWinRate: 0.0)
    var achivedTotals = (damageDealt: 0.0, spotted: 0.0, frags: 0.0, droppedCapturePoints: 0.0, wins: 0.0, battles: 0.0)
    if let tanks = player.tanks {
      for tank in tanks {
        var expValue: expTank?
        for value in exp {
          if value.tankID == tank.tankID {
            expValue = value
          }
        }
        if let expValue = expValue {
          expectedTotals.expDamage += expValue.expDamage * Double((tank.all?.battles)!)
          expectedTotals.expSpot += expValue.expSpot * Double((tank.all?.battles)!)
          expectedTotals.expFrag += expValue.expFrag * Double((tank.all?.battles)!)
          expectedTotals.expDef += expValue.expDef * Double((tank.all?.battles)!)
          expectedTotals.expWinRate += expValue.expWinRate * Double((tank.all?.battles)!)
          achivedTotals.damageDealt += Double((tank.all?.damageDealt)!)
          achivedTotals.spotted += Double((tank.all?.spotted)!)
          achivedTotals.frags += Double((tank.all?.frags)!)
          achivedTotals.droppedCapturePoints += Double((tank.all?.droppedCapturePoints)!)
          achivedTotals.wins += Double((tank.all?.wins)!)
          achivedTotals.battles += Double((tank.all?.battles)!)
        }
      }
    }
    return calculateWN8(achivedTotals, expectedTotals)
  }
  
  func calculateTankWN8(tank: Tank, exp: [expTank]) -> Int {
    var expectedTotals = (expDamage: 0.0, expSpot: 0.0, expFrag: 0.0, expDef: 0.0, expWinRate: 0.0)
    var achivedTotals = (damageDealt: 0.0, spotted: 0.0, frags: 0.0, droppedCapturePoints: 0.0, wins: 0.0, battles: 0.0)
    var expValue: expTank?
    for value in exp {
      if value.tankID == tank.tankID {
        expValue = value
      }
    }
    if let expValue = expValue {
      expectedTotals.expDamage += expValue.expDamage * Double((tank.all?.battles)!)
      expectedTotals.expSpot += expValue.expSpot * Double((tank.all?.battles)!)
      expectedTotals.expFrag += expValue.expFrag * Double((tank.all?.battles)!)
      expectedTotals.expDef += expValue.expDef * Double((tank.all?.battles)!)
      expectedTotals.expWinRate += expValue.expWinRate * Double((tank.all?.battles)!)
      achivedTotals.damageDealt += Double((tank.all?.damageDealt)!)
      achivedTotals.spotted += Double((tank.all?.spotted)!)
      achivedTotals.frags += Double((tank.all?.frags)!)
      achivedTotals.droppedCapturePoints += Double((tank.all?.droppedCapturePoints)!)
      achivedTotals.wins += Double((tank.all?.wins)!)
      achivedTotals.battles += Double((tank.all?.battles)!)
    }
    return calculateWN8(achivedTotals, expectedTotals)
  }

  func calculateWN8(_ tank: (damageDealt: Double, spotted: Double, frags: Double, droppedCapturePoints: Double, wins: Double, battles: Double),
                    _ exp: (expDamage: Double, expSpot: Double, expFrag: Double, expDef: Double, expWinRate: Double)) -> Int {
    let rDamage = tank.damageDealt / exp.expDamage
    let rSpot = tank.spotted / exp.expSpot
    let rFrag = tank.frags / exp.expFrag
    let rDef = tank.droppedCapturePoints / exp.expDef
    let rWin = (100.0*tank.wins) / exp.expWinRate
    let rWinC =    max(0,         (rWin    - 0.71) / (1 - 0.71))
    let rDamageC = max(0,         (rDamage - 0.22) / (1 - 0.22))
    let rFragC =   max(0, min(rDamageC + 0.2, (rFrag - 0.12) / (1 - 0.12)))
    let rSpotC =   max(0, min(rDamageC + 0.1, (rSpot - 0.38) / (1 - 0.38)))
    let rDefC =    max(0, min(rDamageC + 0.1, (rDef  - 0.1)  / (1 - 0.10)))
    let a = 980.0 * rDamageC
    let b = 210.0 * rDamageC*rFragC
    let c = 155.0 * rFragC*rSpotC
    let d = 75.0 * rDefC*rFragC
    let e = 145.0 * min(1.8, rWinC)
    return Int(a + b + c + d + e)
  }
}
