//
//  DashboardView.swift
//  SoundExample
//
//  Created by wirawan sanusi on 10/30/15.
//  Copyright © 2015 Protogres. All rights reserved.
//

import UIKit
import AVFoundation

class DashboardView: UIView, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    
    // True  : means the record button will start recording the sound
    // False : means the record button will stop recording the sound
    var toggleRecordButton = false
    
    @IBAction func didPressRecordButton(sender: AnyObject) {
        
        // Stop the audio player before recording
        if let player = self.player {
            if player.playing {
                self.player?.stop()
            }
        }
        
        // Set toggle into true / false whenever user tapped the record button
        toggleRecordButton = !toggleRecordButton
        
        if toggleRecordButton {
            startRecordingSound()
            
        } else {
            stopRecordingSound()
        }
    }
    
    @IBAction func didPressPlayButton(sender: AnyObject) {
        
        initPlayer()
    }
    
    func initRecorder() {
        
        // Set audio file
        let pathDirectory = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true).last!
        let pathComponents = pathDirectory.stringByAppendingString("Audio.m4a")
        let outputFileURL = NSURL(string: pathComponents)
        print(outputFileURL?.absoluteString)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch let error as NSError {
            // There's an error
            print(error.description)
        }
        
        // Define the recorder setting
        var recordSetting = [String: NSNumber]()
        recordSetting[AVFormatIDKey] = NSNumber(unsignedInt: kAudioFormatMPEG4AAC)
        recordSetting[AVSampleRateKey] = NSNumber(double: 44100.0)
        recordSetting[AVNumberOfChannelsKey] = NSNumber(int: 2)
        
        var recorder: AVAudioRecorder?
        do {
            recorder = try AVAudioRecorder(URL: outputFileURL!, settings: recordSetting)
            
        } catch let error as NSError {
            recorder = nil
            print(error.description)
            
        }
        
        // Initiate and prepare the recorder
        if recorder != nil {
            
            self.recorder = recorder
            self.recorder!.delegate = self
            self.recorder!.meteringEnabled = true
            self.recorder!.prepareToRecord()
        }
    }
    
    func startRecordingSound() {
        
        statusLabel.text = "start recording sound.."
        recordButton.setTitle("Stop", forState: .Normal)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
        } catch let error as NSError {
            // There's an error
            print(error.description)
        }
            
        // Start recording
        self.recorder!.record()
    }
    
    func stopRecordingSound() {
        
        // Stop recording
        self.recorder!.stop()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch let error as NSError {
            // There's an error
            print(error.description)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("success? \(flag)")
        statusLabel.text = "stop recording sound.."
        recordButton.setTitle("Record", forState: .Normal)
    }
    
    func initPlayer() {
        
        statusLabel.text = "play button pressed.."
        
        // Recording it's not in active version
        if !recorder!.recording {
            
            var player: AVAudioPlayer?
            do {
                player = try AVAudioPlayer(contentsOfURL: self.recorder!.url)
            } catch let error as NSError {
                // There's an error
                player = nil
                print(error.description)
            }
            
            if player != nil {
                
                self.player = player
                self.player!.delegate = self
                self.player!.play()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        // You should use delegate here
        statusLabel.text = "Finished playing sound!"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initRecorder()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initRecorder()
    }
}
