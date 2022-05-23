//
//  Section.swift
//  spotifyAutoLayout
//
//  Created by admin on 12/6/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//

import Foundation
struct TrainingSections:Codable {
    var weekDay : String
    var training : [Training]
}
struct Training:Codable {
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
            TrainingSections(weekDay: "Monday", training: []),
            TrainingSections(weekDay: "Tuesday", training: []),
            TrainingSections(weekDay: "Wednesday", training: []),
            TrainingSections(weekDay: "Thursday", training: []),
            TrainingSections(weekDay: "Friday", training: []),
        ]
        return trainings
    }
}
