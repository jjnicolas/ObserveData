import CoreLocation
import GridNavigation
import OSLog
import SwiftData

@Model
public final class PhotoObservation: GridNavigable, Identifiable {
    public var id: UUID = UUID()
    public var timestamp: Date = Date()
    public var name: String = ""
    @Relationship public var species: Species?
    public var latitude: Double?
    public var longitude: Double?
    public var elevation: Double? // Elevation in meters from photo EXIF or device

    // Full resolution photo data
    @Attribute(.externalStorage)
    public var photoData: Data?

    // Thumbnail data (small, optimized for grid views)
    @Attribute(.externalStorage)
    public var thumbnailData: Data?

    public init(
        id: UUID? = nil,
        timestamp: Date = .now,
        name: String = "",
        species: Species? = Species(),
        photoData: Data? = Data(),
        thumbnailData: Data? = Data(),
        location: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 0, longitude: 0),
        elevation: Double? = nil
    ) {
        self.id = id ?? UUID()
        self.timestamp = timestamp
        self.name = name
        self.species = species
        self.photoData = photoData
        self.thumbnailData = thumbnailData
        self.latitude = location?.latitude
        self.longitude = location?.longitude
        self.elevation = elevation
    }
}
