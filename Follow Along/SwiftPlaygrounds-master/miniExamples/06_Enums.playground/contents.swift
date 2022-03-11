// Basic enum
enum WeekDays {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

var today: WeekDays
today = WeekDays.monday

if today == WeekDays.monday {
    print("It is monday")
}


switch today {
case .monday, .wednesday, .friday:
    print("swim practice")
case .thursday:
    print("Horse back riding")
case .tuesday:
    print("Piano practice")
default:
    print("No schedule")
//    break
}




// Rawvalues

enum State: Int {
    case ready = 0
    case set = 1
    case go = 2
}

var raceState = State.ready
raceState.rawValue

var nextRaceState = State(rawValue: 0)
if nextRaceState?.rawValue == 0 {
    print("Ready")
}











// Associated values and functions
enum HomeworkStatus {
    case noHomework
    case inProgress(Int, Int)
    case done
    
    func simpleDescription() -> String {
        switch self {
        case .noHomework:
            return "No Homework"
        case .inProgress(let workDone, let totalProblems):
            return "You have finished \(workDone) out of \(totalProblems) problems"
        case .done:
            return "Done"
        }
    }
}

var myHomeworkStatus = HomeworkStatus.inProgress(8, 10)
myHomeworkStatus.simpleDescription()



