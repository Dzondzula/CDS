import Foundation
struct TrainingSections: Codable {
    var weekDay: WeekDay
    var training: [TrainingInfo]

    static func getTraining() -> [TrainingSections] {
        let trainings = [
            TrainingSections(weekDay: .Monday, training: []),
            TrainingSections(weekDay: .Tuesday, training: []),
            TrainingSections(weekDay: .Wednesday, training: []),
            TrainingSections(weekDay: .Thursday, training: []),
            TrainingSections(weekDay: .Friday, training: [])
        ]
        return trainings
    }
}

enum WeekDay: Int, Codable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case  Friday

    var description: String {
        switch self {
        case .Monday:
                "Monday"
        case .Tuesday:
                "Tuesday"
        case .Wednesday:
                "Wednesday"
        case .Thursday:
                "Thursday"
        case .Friday:
                "Friday"
        }
    }
}

struct TrainingInfo: Codable {

    var title: String
    var image: String
    var time: String

    init(title: String, image: String, time: String) {
        self.title = title
        self.image = image
        self.time = time
    }

    func toAnyObject() -> Any {
        return [
            "trainingType": title,
            "image": image,
            "time": time
        ]
    }
}

class TrainingAPI {
    static func getTraining() -> [TrainingSections] {
        let trainings = [
            TrainingSections(weekDay: .Monday, training: []),
            TrainingSections(weekDay: .Tuesday, training: []),
            TrainingSections(weekDay: .Wednesday, training: []),
            TrainingSections(weekDay: .Thursday, training: []),
            TrainingSections(weekDay: .Friday, training: [])
        ]
        return trainings
    }
}
