//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ankita Satpathy on 30/05/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit
import  AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    
    var audioRecorder = AVAudioRecorder()

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordBtn.isEnabled = false
    }

    
    @IBAction func recordPressed(_ sender: Any) {
        recordLabel.text = "Recording in progress..."
        stopRecordBtn.isEnabled = true
        recordBtn.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "RecordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
       try!  audioRecorder =  AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        recordBtn.isEnabled = true
        recordLabel.text = "Tap to Record"
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try!  audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording unsuccessful")
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioUrl = recordedAudioURL
    }
}

}
