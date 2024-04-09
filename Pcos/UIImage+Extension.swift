//
//  UIImage+Extension.swift
//  Pcos
//
//  Created by SAIL on 08/04/24.
//

import Foundation
import UIKit
import ImageIO

extension UIImage {

    static func animatedGIF(named name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif"),
              let imageData = try? Data(contentsOf: bundleURL),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delaySeconds = delayForImageAtIndex(i, source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Convert to ms
        }

        let duration: Int = delays.reduce(0, +)
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        for i in 0..<count {
            let frame = UIImage(cgImage: images[i])
            let frameCount = delays[i] / gcd
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        return UIImage.animatedImage(with: frames,
                                     duration: Double(duration) / 1000.0)
    }

    static func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.1

        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary? = cfProperties.flatMap {
            let cfProperties = $0 as NSDictionary
            return cfProperties[kCGImagePropertyGIFDictionary] as! CFDictionary
        }
        if let gifProperties = gifProperties {
            var delayTime = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                               Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self) as? Double
            if delayTime == nil {
                delayTime = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                               Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self) as? Double
            }
            if let delayTime = delayTime, delayTime > 0 {
                delay = delayTime
            }
        }

        return delay
    }

    static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty { return 1 }
        return array.reduce(array[0]) { gcd($0, $1) }
    }

    static func gcd(_ a: Int, _ b: Int) -> Int {
        let r = a % b
        if r != 0 {
            return gcd(b, r)
        } else {
            return b
        }
    }
}
