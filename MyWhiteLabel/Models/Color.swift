//
//  Color.swift
//  
//
//  Created by Nikola Andrijašević on 26.11.23..
//

import Foundation

//
//  Color.swift
//  United cloud
//
//  Created by Milos Ljubevski on 9/4/19.
//  Copyright © 2019 United Cloud. All rights reserved.
//

import Foundation
import Client
import UIKit

public struct Color: Codable, Equatable {
    public enum Identifier: String {

        case action
    }

    public enum Keys: CodingKey {
        case identifier
        case color
        case opacity
    }

    let identifier: String
    let hex: String
    let opacity: CGFloat

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.identifier = try container.decodeIfPresent(String.self, forKey: .identifier, fallback: "")
        self.hex = try container.decodeIfPresent(String.self, forKey: .color, fallback: "")
        self.opacity = try container.decodeIfPresent(CGFloat.self, forKey: .opacity, fallback: 1)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.hex, forKey: .color)
        try container.encode(self.opacity, forKey: .opacity)
    }
}


// used for unit tests

public extension Color {
    init(identifier: String, hex: String, opacity: CGFloat) {
        self.identifier = identifier
        self.hex = hex
        self.opacity = opacity
    }
}
