//
//  SpeechClient.swift
//  AzureSpeech
//
//  Created by Colby L Williams on 9/18/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

public class SpeechClient {
    
    public static let shared: SpeechClient = {
        
        let client = SpeechClient()
        
        // config
        
        return client
    }()

    //https://westus.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1
    let deleteMe = "https://westus.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US"
    let deleteMeCustom = "https://westus.stt.speech.microsoft.com/speech/recognition/interactive/cognitiveservices/v1?cid=Ocp-Apim-Subscription-Key"
    
    var tempCount = 0
    
    public func recognize(fileUrl: URL, completion: @escaping (Response<RecognizeResult>) -> Void) {
     
        var request = URLRequest(url: URL(string: tempCount > 0 ? deleteMeCustom : deleteMe)!)
        
        print(request.url?.absoluteString ?? "none")
        
        tempCount = (tempCount + 1)
        
        request.httpMethod = "POST"
        
        request.addValue("audio/wav; codec=audio/pcm; samplerate=16000", forHTTPHeaderField: "Content-Type")
        request.addValue("Ocp-Apim-Subscription-Key", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        URLSession.shared.uploadTask(with: request, fromFile: fileUrl) { data, response, error in
            
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            
            let httpResponse = response as? HTTPURLResponse
            
            if let error = error {
                
                completion(Response(request: request, data: data, response: httpResponse, result: .failure(error)))
                
            } else if let data = data {
                
                do {
                    
                    print("Status Code: \(httpResponse?.statusCode ?? 0)")
                    
                    let resource = try self.decoder.decode(RecognizeResult.self, from: data)
                    
                    completion(Response(request: request, data: data, response: httpResponse, result: .success(resource)))
                    
                } catch {
                    
                    completion(Response(request: request, data: data, response: httpResponse, result: .failure(error)))
                }
            } else {
                completion(Response(request: request, data: data, response: httpResponse, result: .failure(SpeechClientError.unknown)))
            }
        }.resume()
    }
    
    
    
    // MARK: - JSON Encoder/Decoder
    
    static let iso8601Formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.calendar      = Calendar(identifier: .iso8601)
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.timeZone      = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return formatter
    }()
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(iso8601Formatter)
        return encoder
    }()
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Formatter)
        return decoder
    }()
}


// MARK: -

public enum SpeechClientError : Error {
    case unknown
    case invalidIds
    case noConversation
    case urlError(String)
    case decodeError(DecodingError)
    case encodingError(EncodingError)
    //case apiError(ApiError?)
}

