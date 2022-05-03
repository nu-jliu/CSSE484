// We already know about constants vs variables but there is another choice always present.
var x = 7
var f: Float = 7
let dave = "Dave"
//dave = "Bob"  // Would cause an error

// Part 1.
// Optionals
var optionalFloat: Float?
var requiredFloat: Float
var implicitlyUnwrappedFloat: Float!

optionalFloat = 5.0
requiredFloat = 5.0

print("Optioal Float = \(optionalFloat)")
print("Required Float = \(requiredFloat)")

// Optionals with forced unwrapping

print("Optional Float = \(optionalFloat)")

let name = "Dave"
let number = "7"
var optioalThatIsNill: Int? = Int(name)
var optionalThisIsNotNill: Int = Int(number)!

optioalThatIsNill
optionalThisIsNotNill

// Part 2.
import UIKit
import Foundation
// Views in a Playground + Optional Chaining
let b = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
b.backgroundColor = UIColor.red

b.setTitle("Press Me!!", for: .normal)

print(b.titleLabel)
print(b.titleLabel?.text) // optional printing
print(b.titleLabel!.text) // required printing

print(b.titleLabel!.text!)

// Optional Binding

if let myText = b.titleLabel?.text {
    print("There is text and the value is \(myText)")
} else {
    print("There is no text on the label")
}


// Implicitly Unwrapped Optionals
let myImplicitlyUnrappedOptionalLabel: UILabel! = b.titleLabel

print(myImplicitlyUnrappedOptionalLabel.text)
print(myImplicitlyUnrappedOptionalLabel.text!)
