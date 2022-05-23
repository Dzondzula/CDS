

import Foundation
struct TrainingSections:Codable {
    var weekDay : WeekDay
    var training : [TrainingInfo]
}
enum WeekDay: String,Codable{
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case  Friday = "Friday"
    
 
}
struct TrainingInfo:Codable {
    init(title: String, image: String, time: String) {
        self.title = title
        self.image = image
        self.time = time
    }
    
    var title: String
    var image : String
    var time : String
    
    
    func toAnyObject()-> Any{
        return [
            "trainingType": title,
            "image": image,
            "time": time,
        ]
    }
    
}

class TrainingAPI {
    static func getTraining() -> [TrainingSections]{
        let trainings = [
            TrainingSections(weekDay: .Monday, training: []),
            TrainingSections(weekDay: .Tuesday, training: []),
            TrainingSections(weekDay: .Wednesday, training: []),
            TrainingSections(weekDay: .Thursday, training: []),
            TrainingSections(weekDay: .Friday, training: []),
        ]
        return trainings
    }
}
