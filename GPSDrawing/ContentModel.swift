//
//  ContentModel.swift
//  GPSDrawing
//
//  Created by Kanta Oikawa on 2024/06/07.
//

import CoreLocation
import Foundation
import Observation

@Observable
final class ContentModel {
    private(set) var coordinates: [CLLocationCoordinate2D] = []
    private(set) var route: [CLLocationCoordinate2D] = []
    private(set) var isLoading: Bool = false
    private(set) var alertMessage: String?
    var isAlertPresented: Bool {
        get { alertMessage != nil }
        set(newValue) {
            if newValue == false {
                alertMessage = nil
            }
        }
    }

    func setCoordinates(_ coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }

    func getRoute() async {
        isLoading = true
        defer { isLoading = false }
        let url = URL(string: "https://router.project-osrm.org/route/v1/foot/\(coordinates.map { "\($0.longitude),\($0.latitude)" }.joined(separator: ";"))?overview=false&steps=true")!
        debugPrint(url.absoluteString)
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                route = []
                alertMessage = "Failed to get response"
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                route = []
                alertMessage = "Response: \(response.statusCode)"
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let osrmResponse = try decoder.decode(OSRMResponse.self, from: data)
            guard let routes = osrmResponse.routes.first else {
                route = []
                alertMessage = "No Route"
                return
            }
            route = routes.legs.flatMap {
                $0.steps.flatMap {
                    $0.intersections.map {
                        CLLocationCoordinate2D(latitude: $0.location[1], longitude: $0.location[0])
                    }
                }
            }
        } catch {
            route = []
            alertMessage = error.localizedDescription
        }
    }
}
