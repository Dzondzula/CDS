//
//  Section.swift
//  spotifyAutoLayout
//
//  Created by admin on 12/6/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//

import Foundation
struct Section:Codable {
    var weekDay : String
    var training : [Training]
}
struct Training:Codable {
    var title: String
    var image : String
}

class TrainingAPI {
    static func getTraining() -> [Section]{
        let trainings = [
            Section(weekDay: "Monday", training: []),
            Section(weekDay: "Tuesday", training: []),
            Section(weekDay: "Wednesday", training: []),
            Section(weekDay: "Thursday", training: []),
            Section(weekDay: "Friday", training: []),
        ]
        return trainings
    }
}
