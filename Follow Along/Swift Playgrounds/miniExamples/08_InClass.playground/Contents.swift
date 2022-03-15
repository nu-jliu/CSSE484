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
