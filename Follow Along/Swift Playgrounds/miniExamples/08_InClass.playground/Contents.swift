import UIKit

var greeting = "Hello, playground"


var totalPassing: Int = 0
var scores = [50, 40, 80, 90, 75, 80]

for score in scores {
    if score >= 60 {
        totalPassing += 1
    }
}
totalPassing

for i in 0..<10 {
    print(i)
}

for i in 0...20 {
    print(i)
}

totalPassing = 0
for i in 0..<scores.count {
    if scores[i] >= 60 {
        totalPassing += 1
    }
}
totalPassing

import UIKit
import Foundation

var number: String = "100"
var dave: String = "Dave"

var b = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
b.setTitle("Button", for: .normal)

print(b.titleLabel)
print(b.titleLabel!.text)
print(b.titleLabel?.text)
print(b.titleLabel!.text!)

if let tempVariable = Int(number) {
    print("Temp variable is \(tempVariable)")
} else {
    print("There is no temp variable")
}

if let tempVariable = Int(dave) {
    print("Temp variable is \(tempVariable)")
} else {
    print("There is no temp variable")
}

enum Weekday {
    case monday, tuesday, wednesday, thursday, friday
}

var today: Weekday = .tuesday

switch today {
case .monday, .tuesday, .thursday:
    print("You have classes");
case .wednesday:
    print("Weekend Wednesday!");
default:
    print("It is the weekend");
}

enum State: Int {
    case ready = 0
    case steady
    case go
}

var raceState = State.go
type(of: raceState)

var nextRaceState = State(rawValue: 2)
type(of: nextRaceState)
nextRaceState?.rawValue

if nextRaceState == .go {
    print("Go!!!")
}

enum HomeworkStatus {
    case noHomework
    case inProgress(Int, Int)
    case done
    
    func simpleDescription() -> String {
        switch self {
        case .noHomework:
            return "No Homework"
        case .inProgress(let numComplete, let total):
            return "You have finished \(numComplete) out of \(total), remaining \(total - numComplete)"
        case .done:
            return "You finished homeworks"
        }
    }
}

var myHwStatus = HomeworkStatus.inProgress(6, 10)
var myHwStatus2 = HomeworkStatus.inProgress(8, 100)

myHwStatus.simpleDescription()
myHwStatus2.simpleDescription()

class BankAccount: CustomStringConvertible {
    
    var name: String
    var balance: Double
    
    init(name: String, balance: Double) {
        self.name = name
        self.balance = balance
    }
    
    func deposit(_ amount: Double) {
        self.balance += amount
    }
    
    func withdraw(_ amount: Double) {
        self.balance -= amount
    }
    
    var description: String {
        get {
            return "\(self.name): $\(self.balance)"
        }
    }
}

var allenAccount = BankAccount(name: "Allen", balance: 2890)
allenAccount.deposit(200)
allenAccount.balance
allenAccount.withdraw(80)
allenAccount.balance

class ATMAccount: BankAccount {
    
    var withdrawFee: Double
    
    init(name: String, balance: Double, withdrawFee: Double) {
        self.withdrawFee = withdrawFee
        super.init(name: name, balance: balance)
    }
    
    convenience init() {
        self.init(name: "Unknown", balance: 0.0)
    }
    
    override convenience init(name: String, balance: Double) {
        self.init(name: name, balance: balance, withdrawFee: 2.0)
    }
    
    override func withdraw(_ amount: Double) {
        self.balance -= self.withdrawFee
        super.withdraw(amount)
    }
    
    override var description: String {
        get {
            return super.description + ", Fee: $\(self.withdrawFee)"
        }
    }
}
