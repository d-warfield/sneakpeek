//
//  ResizeImage.swift
//  sneakpeek
//
//  Created by Dennis Warfield on 5/13/22.
//
import SwiftUI
import Foundation

extension UIImage {
    func scalePreservingAspectRatio(width: Int, height: Int) -> UIImage {
        let widthRatio = CGFloat(width) / size.width
        let heightRatio = CGFloat(height) / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize,
            format: format
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
