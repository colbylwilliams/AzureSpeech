//
//  UtilityExtensions.swift
//  AzureSpeech
//
//  Created by Colby L Williams on 9/18/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation


extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


extension Bundle {
    func plist(named name: String) -> Data? {
        if let url = self.url(forResource: name.removingSuffix(".plist"), withExtension: "plist") {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}


extension UIImage {
    
    func cropToSquare() -> UIImage {
        
        let refWidth = CGFloat((self.cgImage!.width))
        let refHeight = CGFloat((self.cgImage!.height))
        let cropSize = refWidth > refHeight ? refHeight : refWidth
        
        let x = (refWidth - cropSize) / 2.0
        let y = (refHeight - cropSize) / 2.0
        
        let cropRect = CGRect(x: x, y: y, width: cropSize, height: cropSize)
        let imageRef = self.cgImage?.cropping(to: cropRect)
        let cropped = UIImage(cgImage: imageRef!, scale: 0.0, orientation: self.imageOrientation)
        
        return cropped
    }
}


extension String {
    
    func ensuringSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return self
        }
        return self + suffix
    }
    
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
}


extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
    
    var valueOrEmpty: String {
        return self != nil ? self! : ""
    }
}


extension Optional where Wrapped == String {
    mutating func add (_ queryKey: String, _ queryValue: Any?) {
        if self == nil, let queryValue = queryValue {
            
            if let queryValueString = queryValue as? String, queryValueString.isEmpty {
                return
            }
            
            var queryValueString = "\(queryValue)".replacingOccurrences(of: " ", with: "%20")
            
            if let queryValueArray = queryValue as? [String], !queryValueArray.isEmpty {
                queryValueString = queryValueArray.joined(separator: ",").replacingOccurrences(of: "\\\"", with: "")
            }
            
            if !queryValueString.isEmpty {
                self = "?\(queryKey)=\(queryValueString)"
            }
        } else {
            self!.add(queryKey, queryValue)
        }
    }
}

extension String {
    mutating func add (_ queryKey: String, _ queryValue: Any?) {
        if let queryValue = queryValue {
            
            if let queryValueString = queryValue as? String, queryValueString.isEmpty {
                return
            }
            
            var queryValueString = "\(queryValue)".replacingOccurrences(of: " ", with: "%20")
            
            if let queryValueArray = queryValue as? [String], !queryValueArray.isEmpty {
                queryValueString = queryValueArray.joined(separator: ",").replacingOccurrences(of: "\\\"", with: "")
            }
            
            if !queryValueString.isEmpty {
                if self.contains("?") {
                    self += "&\(queryKey)=\(queryValueString)"
                } else {
                    self = "?\(queryKey)=\(queryValueString)"
                }
            }
        }
    }
}
