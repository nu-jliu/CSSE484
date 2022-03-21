//
//  LinearLightsOutGame.swift
//  Linear Lights Out Universal
//
//  Created by Jingkun Liu on 3/17/22.
//

import Foundation

class LinearLightsOutGame: CustomStringConvertible {
    var lightStates : [Bool] = []
    var numMoves: Int = 0
    
    init(numLights: Int) {
        if numLights < 5 || numLights % 2 == 0 {
            print("ERROR: unwinnable game")
            return
        }
        
        self.numMoves = 0
        var newStates: [Bool] = [Bool](repeating: false, count: numLights)
        
        for i in 0..<numLights {
            newStates[i] = Bool.random()
        }
        
        self.lightStates = newStates
    }
    
    func pressedLightAtIndex(at index: Int) -> Bool {
        if self.allLightsOff() {
            return true
        }
        
        self.toggleLightState(index - 1)
        self.toggleLightState(index)
        self.toggleLightState(index + 1)
        
        self.numMoves += 1
        
        return self.allLightsOff()
    }
    
    func toggleLightState(_ index: Int) {
        if index >= 0 && index < self.lightStates.count {
            self.lightStates[index] = !self.lightStates[index]
        }
    }
    
    func allLightsOff() -> Bool {
        for states in self.lightStates {
            if states {
                return false
            }
        }
        return true
    }
    
    var description: String {
        var outStr: String = "Lights: "
        for state in self.lightStates {
            state ? outStr.append("1") : outStr.append("0")
        }
        
        outStr.append(", Moves: \(self.numMoves)")
        
        return outStr
    }
}
