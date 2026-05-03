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

    /// Human-readable place name resolved from `latitude`/`longitude` via reverse
    /// geocoding (e.g. "San Diego Zoo Safari Park"). Lazily populated the first
    /// time the detail view opens for an observation with coordinates; cleared
    /// when coordinates change so it gets re-resolved. `nil` means "not yet
    /// resolved" — never an empty string.
    public var locationName: String?

    /// Seconds east of UTC for the photo's original capture timezone, when known.
    /// `timestamp` is always an absolute UTC instant; this offset is used purely
    /// for display so the photo shows at the same wall-clock time as in Photos.app
    /// regardless of where the user currently is. `nil` for older rows imported
    /// before the field existed — display falls back to the device's current zone.
    public var timezoneOffsetSeconds: Int?

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
        elevation: Double? = nil,
        timezoneOffsetSeconds: Int? = nil,
        locationName: String? = nil
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
        self.timezoneOffsetSeconds = timezoneOffsetSeconds
        self.locationName = locationName
    }

    /// TimeZone reconstructed from the stored offset, or nil when unknown
    /// (display sites should fall back to `.current` in that case).
    public var captureTimeZone: TimeZone? {
        guard let timezoneOffsetSeconds else { return nil }
        return TimeZone(secondsFromGMT: timezoneOffsetSeconds)
    }
}
