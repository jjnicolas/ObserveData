import CoreLocation
import Foundation

struct JSONObservation: Codable, Sendable {
    let id: String
    let timestamp: Date
    let name: String
    let leafIndex: Int
    let locationData: LocationCoordinate?
    let imageBase64: String?
}

// Wrapper to avoid extending imported types
struct LocationCoordinate: Codable, Sendable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    nonisolated init(coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }

    nonisolated var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}