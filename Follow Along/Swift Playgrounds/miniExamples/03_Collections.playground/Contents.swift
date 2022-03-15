import UIKit

// Basics for arrays
var names = ["Dave", "Kristy", "McKinley", "Keegan", "Bowen", "Neala"]
names[1]
names[2] = "Hello"
names.count

if names.contains("Dave") {
    print("Yes, it is present")
}

// Appending values
var ages = [Int]()
ages.append(37)
ages.append(4)
ages.insert(10, at: 0)

ages

ages += [1, 3, 7]
ages

if ages.isEmpty {
    print("Yes it is empty")
} else {
    print("Array has \(ages.count) elements")
}






// So, so, SO.. many things you could do with arrays...
var randomAges = [Int]()
for _ in 0..<100 {
    randomAges.append(Int(arc4random_uniform(90)))
}
var teenagers = randomAges.filter({
    return $0 > 12 && $0 < 20
})
teenagers = teenagers.sorted(by: {
    return $0 < $1
})

teenagers = teenagers.map({
    return $0 + 100
})

teenagers


// Dictionaries
var elements = ["H": "Hydrogen", "He": "Helium", "Li": "Lithium", "Be": "Beryllium", "B": "Boron", "C": "Carbon", "N": "Nitrogen", "O": "Oxygen"]
elements["C"]!
elements["Z"]
for (symbol, name) in elements {
    if symbol == "H" || symbol == "O" {
        print("\(name) is present in water.")
    }
}


// Tuples - There is one really good use for a tuple (coming soon).
var tuple = ("item1", "item2", "item3", "item4")
tuple.2
var namedTuple = (first : "Dave", last : "Fisher")
namedTuple.last
namedTuple.first

namedTuple.1
