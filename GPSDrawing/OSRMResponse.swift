//
//  OSRMResponse.swift
//  GPSDrawing
//
//  Created by Kanta Oikawa on 2024/06/07.
//

import Foundation

struct OSRMResponse: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let legs: [Leg]
}

struct Leg: Codable {
    let steps: [Step]
}

struct Step: Codable {
    let intersections: [Intersection]
}

struct Intersection: Codable {
    let location: [Double]
}
