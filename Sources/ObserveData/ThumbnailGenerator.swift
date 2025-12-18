import CoreGraphics
import Foundation
import OSLog

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public enum ThumbnailGenerator {
    /// Standard thumbnail size for grid views (optimized for modern displays)
    static let thumbnailSize: CGSize = .init(width: 200, height: 200)

    /// JPEG compression quality for thumbnails (higher quality for better grid display)
    static let compressionQuality: CGFloat = 0.8

    /// Generates a thumbnail from image data
    /// - Parameter imageData: Original image data
    /// - Returns: Compressed thumbnail data or nil if generation fails
    public static func generateThumbnail(from imageData: Data) -> Data? {
        #if os(macOS)
            return generateThumbnailMacOS(from: imageData)
        #else
            return generateThumbnailIOS(from: imageData)
        #endif
    }

    #if os(macOS)
        private static func generateThumbnailMacOS(from imageData: Data) -> Data? {
            guard let nsImage = NSImage(data: imageData) else {
                AppLogger.thumbnail.error("Failed to create NSImage from data")
                return nil
            }

            let originalSize = nsImage.size
            let targetSize = thumbnailSize // Fixed size

            // Calculate crop rectangle for aspect-fill
            let aspectRatio = originalSize.width / originalSize.height
            let targetAspectRatio = targetSize.width / targetSize.height

            let sourceRect: NSRect
            if aspectRatio > targetAspectRatio {
                // Image is wider - crop width
                let newWidth = originalSize.height * targetAspectRatio
                let offsetX = (originalSize.width - newWidth) / 2
                sourceRect = NSRect(x: offsetX, y: 0, width: newWidth, height: originalSize.height)
            } else {
                // Image is taller - crop height
                let newHeight = originalSize.width / targetAspectRatio
                let offsetY = (originalSize.height - newHeight) / 2
                sourceRect = NSRect(x: 0, y: offsetY, width: originalSize.width, height: newHeight)
            }

            // Create thumbnail image using modern approach
            let thumbnailImage = NSImage(size: targetSize)

            // Create bitmap representation directly
            guard let bitmapRep = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: Int(targetSize.width),
                pixelsHigh: Int(targetSize.height),
                bitsPerSample: 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: .deviceRGB,
                bytesPerRow: 0,
                bitsPerPixel: 0
            ) else {
                AppLogger.thumbnail.error("Failed to create bitmap representation")
                return nil
            }

            // Create graphics context
            guard let context = NSGraphicsContext(bitmapImageRep: bitmapRep) else {
                AppLogger.thumbnail.error("Failed to create graphics context")
                return nil
            }

            // Set as current context and draw
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = context
            context.imageInterpolation = .high

            // Fill with transparent background
            NSColor.clear.set()
            NSRect(origin: .zero, size: targetSize).fill()

            nsImage.draw(in: NSRect(origin: .zero, size: targetSize),
                         from: sourceRect,
                         operation: .copy,
                         fraction: 1.0)

            NSGraphicsContext.restoreGraphicsState()

            let jpegData = bitmapRep.representation(
                using: .jpeg,
                properties: [.compressionFactor: compressionQuality]
            )

            if let jpegData {
//                print("Generated thumbnail: \(imageData.count) bytes -> \(jpegData.count) bytes")
                AppLogger.thumbnail.debug("Generated thumbnail: \(imageData.count) bytes -> \(jpegData.count) bytes")
            } else {
                print("Failed to generate JPEG data")
                AppLogger.thumbnail.error("Failed to generate JPEG data")
            }

            return jpegData
        }
    #else
        private static func generateThumbnailIOS(from imageData: Data) -> Data? {
            guard let uiImage = UIImage(data: imageData) else {
                AppLogger.thumbnail.error("Failed to create UIImage from data")
                return nil
            }

            let originalSize = uiImage.size
            let targetSize = thumbnailSize // Always 400x400

            // Calculate crop rectangle for aspect-fill
            let aspectRatio = originalSize.width / originalSize.height
            let targetAspectRatio = targetSize.width / targetSize.height

            let sourceRect: CGRect
            if aspectRatio > targetAspectRatio {
                // Image is wider - crop width
                let newWidth = originalSize.height * targetAspectRatio
                let offsetX = (originalSize.width - newWidth) / 2
                sourceRect = CGRect(x: offsetX, y: 0, width: newWidth, height: originalSize.height)
            } else {
                // Image is taller - crop height
                let newHeight = originalSize.width / targetAspectRatio
                let offsetY = (originalSize.height - newHeight) / 2
                sourceRect = CGRect(x: 0, y: offsetY, width: originalSize.width, height: newHeight)
            }

            // Create thumbnail with high quality
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let thumbnailImage = renderer.image { context in
                // Set high quality interpolation
                context.cgContext.interpolationQuality = .high

                // Draw cropped portion of original image to fill the square
                if let cgImage = uiImage.cgImage?.cropping(to: sourceRect) {
                    let croppedImage = UIImage(cgImage: cgImage, scale: uiImage.scale, orientation: uiImage.imageOrientation)
                    croppedImage.draw(in: CGRect(origin: .zero, size: targetSize))
                } else {
                    // Fallback to simple draw if cropping fails
                    uiImage.draw(in: CGRect(origin: .zero, size: targetSize))
                }
            }

            // Convert to JPEG data
            let jpegData = thumbnailImage.jpegData(compressionQuality: compressionQuality)

            if let jpegData {
                AppLogger.thumbnail.debug("Generated thumbnail: \(imageData.count) bytes -> \(jpegData.count) bytes")
            } else {
                AppLogger.thumbnail.error("Failed to generate JPEG data")
            }

            return jpegData
        }
    #endif

    /// Calculates aspect-fill size for square thumbnails (crops to fit)
    private static func aspectFitSize(original _: CGSize, target: CGSize) -> CGSize {
        // For square thumbnails, we want to crop to fill the square
        // This ensures consistent 400x400 dimensions for all thumbnails
        target
    }

    /// Estimates memory savings from using thumbnails vs full images
    static func estimateMemorySavings(originalSize: Int, thumbnailSize: Int) -> (savingsBytes: Int, savingsPercent: Double) {
        let savings = originalSize - thumbnailSize
        let percent = Double(savings) / Double(originalSize) * 100
        return (savings, percent)
    }
}
