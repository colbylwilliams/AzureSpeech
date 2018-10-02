//
//  SpeechRecorder.swift
//  AzureSpeech
//
//  Created by Colby L Williams on 9/18/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import AVFoundation

public class SpeechRecorder: NSObject, AVAudioRecorderDelegate {
    
    public static let shared: SpeechRecorder = {
        
        let recorder = SpeechRecorder()
        
        // config
        
        return recorder
    }()

    var recordingTime: TimeInterval = 0
    
    var minimumRecordingTime: TimeInterval = 3
    
    var audioFilename: URL { return getDocumentsDirectory().appendingPathComponent("recording.wav") }
    
    private var audioRecorder: AVAudioRecorder?

    private let settings = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),  // Encoding PCM
        AVSampleRateKey: 16000,                     // Rate 16K (16 KHz)
        AVNumberOfChannelsKey: 1,                   // Channels Mono
        AVEncoderBitRateKey: 16,                    // Sample Format 16 bit
        AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]

    
    public func startRecording() {
        
        print("Start recording...")
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            print("recording...")
            //updateFeedback(feedbackLabel: PipStrings.recording, auxLabel: PipStrings.touchToStop)
            
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
            finishRecording(success: false)
        }
    }
    

    public func finishRecording(success: Bool) {
        print("Stop recording...")
        
        //updateFeedback(feedbackLabel: PipStrings.processing)
        
        recordingTime = audioRecorder?.currentTime ?? 0
        
        audioRecorder?.stop()

        //  audioRecorder = nil
        
        if success {
            print("Recording succeeded")
        } else {
            print("Recording failed")
        }
    }
    
    
    
    // MARK: - AVAudioRecorderDelegate
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Recorder Encode Error: \(error?.localizedDescription ?? "")")
    }
    
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio Recorder finished recording (\(flag ? "successfully" : "unsuccessfully"))")
        
        if flag {
            
            if recordingTime < minimumRecordingTime {
            
                print("Recording is under \(minimumRecordingTime) seconds.  Deleting (\(recorder.deleteRecording() ? "successfully" : "unsuccessfully"))")
            
            } else {
                
                SpeechClient.shared.recognize(fileUrl: audioFilename) { r in
                    
                    r.printResponseData()
                }
                
                SpeechClient.shared.recognize(fileUrl: audioFilename) { r in
                    
                    r.printResponseData()
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
