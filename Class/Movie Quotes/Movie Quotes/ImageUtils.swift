//
//  ImageUtils.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 4/25/22.
//

import Foundation
import UIKit
import Kingfisher

class ImageUtils {
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            imageView.kf.setImage(with: imgUrl)
            
            if let image = imageView.image {
                imageView.image = self.cropImageToSquare(image: image)
            }
//            DispatchQueue.global().async { // Download in the background
//                do {
//                    let data = try Data(contentsOf: imgUrl)
//                    DispatchQueue.main.async { // Then update on main thread
//                        imageView.image = UIImage(data: data)
//                    }
//                } catch {
//                    print("Error downloading image: \(error)")
//                }
//            }
        }
    }
    
    // From https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
    static func resize(image: UIImage, maxHeight: Float = 200.0, maxWidth: Float = 200.0, compressionQuality: Float = 0.5) -> Data? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData
    }
    
    static func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
}
