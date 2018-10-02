//
//  ViewController.swift
//  Example
//
//  Created by Colby L Williams on 9/18/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import UIKit
import AzureSpeech

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonTouchDown(_ sender: Any) {
        (sender as? UIButton)?.backgroundColor = UIColor.green

        print("Recording...")
        
        SpeechRecorder.shared.startRecording()
    }
    
    @IBAction func buttonTouchEnded(_ sender: Any) {
        (sender as? UIButton)?.backgroundColor = UIColor.white
        
        print("End Recording...")
        
        SpeechRecorder.shared.finishRecording(success: true)
    }
}

