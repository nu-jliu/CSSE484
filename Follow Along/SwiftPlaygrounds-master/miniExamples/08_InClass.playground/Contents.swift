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
