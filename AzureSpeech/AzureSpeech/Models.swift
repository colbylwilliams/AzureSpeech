//
//  Models.swift
//  AzureSpeech
//
//  Created by Colby L Williams on 9/18/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation


public struct RecognizeResult: Codable {
    
    public let recognitionStatus: String
    public let offset, duration: Double
    public let displayText: String?
    
    public let interpretations: [Interpretation]?
    
    enum CodingKeys: String, CodingKey {
        case recognitionStatus  = "RecognitionStatus"
        case displayText        = "DisplayText"
        case offset             = "Offset"
        case duration           = "Duration"
        case interpretations    = "NBest"
    }
    
    public struct Interpretation: Codable {
        
        public let lexical, itn, maskedITN: String
        public let confidence: Double
        public let display: String
        
        enum CodingKeys: String, CodingKey {
            case confidence = "Confidence"
            case lexical    = "Lexical"
            case itn        = "ITN"
            case maskedITN  = "MaskedITN"
            case display    = "Display"
        }
    }
}
