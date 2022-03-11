// Basic function

func stringRepeater(_ orgStr: String, _ repeatCount: Int) -> String {
    var returnStr = ""
    for _ in 0..<repeatCount {
        returnStr += orgStr
    }
    return returnStr
}

stringRepeater("Ho!", 3)
stringRepeater("New York ", 2)




// Returning a tuple (multiple return values)


func stringLetterRepeater(_ orgStr: String, _ repeatCount: Int) -> (String, String) {
    let version1 = stringRepeater(orgStr, repeatCount)
    
    var version2 = ""
    
    for letter in orgStr {
        version2 += String(repeating: letter, count: repeatCount)
    }
    
    return (version1, version2)
}



var collated : String, uncollated : String
(collated, uncollated) = stringLetterRepeater("Ow! ", 4)
collated
uncollated







// Internal/External names plus Optional parameters


func stringDoubler(_ orgString: String, alternativeMultiple repeatCount: Int = 2) -> String {
    var returnStr = ""
    
    for _ in 0..<repeatCount {
        returnStr += orgString
    }
    
    return returnStr
}




stringDoubler("Woof! ", alternativeMultiple: 3)
stringDoubler("Jingle Bells! ")
