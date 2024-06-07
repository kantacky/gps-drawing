//
//  ContentView.swift
//  GPSDrawing
//
//  Created by Kanta Oikawa on 2024/06/07.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @Bindable private var model = ContentModel()

    var body: some View {
        Map {
            MapPolyline(coordinates: model.route)
                .stroke(Color.red, lineWidth: 2)
        }
        .overlay {
            if model.isLoading {
                ProgressView()
            }
        }
        .task {
            model.setCoordinates([
                CLLocationCoordinate2DMake(41.809953, 140.750836),
                CLLocationCoordinate2DMake(41.807658, 140.758564),
                CLLocationCoordinate2DMake(41.808239, 140.758850),
                CLLocationCoordinate2DMake(41.807330, 140.762755),
                CLLocationCoordinate2DMake(41.806069, 140.761980),
                CLLocationCoordinate2DMake(41.804197, 140.764440),
                CLLocationCoordinate2DMake(41.801347, 140.764592),
                CLLocationCoordinate2DMake(41.800625, 140.763995),
                CLLocationCoordinate2DMake(41.798623, 140.764053),
                CLLocationCoordinate2DMake(41.797513, 140.765276),
                CLLocationCoordinate2DMake(41.796347, 140.767663),
                CLLocationCoordinate2DMake(41.798001, 140.763250),
                CLLocationCoordinate2DMake(41.796783, 140.763453),
                CLLocationCoordinate2DMake(41.796385, 140.761575),
                CLLocationCoordinate2DMake(41.798551, 140.762175),
                CLLocationCoordinate2DMake(41.804143, 140.751231),
                CLLocationCoordinate2DMake(41.803350, 140.751138),
                CLLocationCoordinate2DMake(41.803215, 140.741248),
                CLLocationCoordinate2DMake(41.805650, 140.741392),
                CLLocationCoordinate2DMake(41.807139, 140.745146),
                CLLocationCoordinate2DMake(41.809091, 140.745813),
                CLLocationCoordinate2DMake(41.809953, 140.750836),
            ])
            await model.getRoute()
        }
        .alert(
            "Error",
            isPresented: $model.isAlertPresented,
            presenting: model.alertMessage,
            actions: { _ in },
            message: Text.init
        )
    }
}

#Preview {
    ContentView()
}
