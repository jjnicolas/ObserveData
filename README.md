# ObserveData

A Swift package for managing photo observations with species identification and taxonomic classification.

## Features

- **Photo Management**: Store and manage photo observations with full resolution and thumbnail support
- **Species Identification**: Track species information with taxonomic hierarchy
- **Location Data**: GPS coordinates and elevation tracking from photo EXIF or device
- **SwiftData Integration**: Persistent storage using SwiftData models
- **CoreML Support**: Machine learning classification for species identification
- **Grid Navigation**: Built-in support for grid-based UI navigation

## Requirements

- iOS 18.0+ / macOS 15.0+
- Swift 6.2+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add ObserveData to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/jjnicolas/ObserveData", branch: "main")
]
```

Then add it to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["ObserveData"]
    )
]
```

## Usage

### Creating a Photo Observation

```swift
import ObserveData
import CoreLocation

let observation = PhotoObservation(
    timestamp: Date(),
    name: "Red-tailed Hawk",
    species: species,
    photoData: imageData,
    location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
    elevation: 50.0
)
```

### Working with Species

```swift
let species = Species(
    leafIndex: 42,
    name: "Buteo jamaicensis",
    taxonId: 12345,
    lineage: [
        TaxonInfo(taxonId: 1, name: "Animalia", rank: 1),
        TaxonInfo(taxonId: 2, name: "Chordata", rank: 2),
        TaxonInfo(taxonId: 3, name: "Aves", rank: 3)
    ]
)
```

### Taxonomic Classification

The package includes support for hierarchical taxonomic classification with CoreML integration:

```swift
// Access taxonomic lineage
if let lineage = species.lineage {
    for taxon in lineage {
        print("\(taxon.name) (Rank: \(taxon.rank))")
    }
}
```

## Models

### PhotoObservation

The main model for storing photo-based observations:

- `id`: Unique identifier (UUID)
- `timestamp`: Date and time of observation
- `name`: Observation name or description
- `species`: Associated species information
- `latitude`/`longitude`: GPS coordinates
- `elevation`: Elevation in meters
- `photoData`: Full resolution photo (external storage)
- `thumbnailData`: Optimized thumbnail (external storage)

### Species

Species information with taxonomic hierarchy:

- `id`: Unique identifier (UUID)
- `name`: Species name
- `leafIndex`: Classification leaf index for CoreML
- `taxonId`: Taxonomic identifier
- `observations`: Related photo observations
- `lineage`: Full taxonomic hierarchy from kingdom to species

### TaxonInfo

Lightweight structure representing a single taxonomic level:

- `taxonId`: Unique taxonomic identifier
- `name`: Taxonomic name
- `rank`: Hierarchical rank level

## Dependencies

- [GridNavigation](https://github.com/jjnicolas/GridNavigation): Grid-based navigation support

## License

MIT License

Copyright (c) 2025 Julien Nicolas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Julien Nicolas

## Version History

- **1.0.0** - Initial release
