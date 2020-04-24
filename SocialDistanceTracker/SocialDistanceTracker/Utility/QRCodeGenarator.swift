//
//  QRCodeGenarator.swift
//  SocialDistanceTracker
//
//  Created by Dilip Sabat on 24/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import Foundation
import UIKit

class QRCodeGenarator {
    static func generateQRCode(dictData: Dictionary<String, String>) -> UIImage?{
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dictData) {
            if let qrCodeString = String(data: jsonData, encoding: .utf8) {
                let data = qrCodeString.data(using: String.Encoding.ascii)
                guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
                qrFilter.setValue(data, forKey: "inputMessage")
                guard let qrImage = qrFilter.outputImage else { return nil}
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrImage = qrImage.transformed(by: transform)
                guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil}
                colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
                guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil}
                guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil}
                maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
                guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil}
                let context = CIContext()
                guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil}
                let processedImage = UIImage(cgImage: cgImage)
                return processedImage
            }
        }
        return nil
    }
}
