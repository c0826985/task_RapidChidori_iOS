//
//  AudioViewController.swift
//  task_RapidChidori_iOS
//
//  Created by Kaushil Prajapati on 26/01/22.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    var fileName = "audio_file.m4a"
    
    var recorder : AVAudioRecorder!
    var player : AVAudioPlayer!
    var recordSession : AVAudioSession!
    
    @IBAction func PlayRecordedAudio(_ sender: Any) {
//
//        if sender.titleLabel?.text == "Play" {
//                  recordBtn.isEnabled = false
//                  sender.setTitle("Stop", for: .normal)
//                  preparePlayer()
//                  audioPlayer.play()
//              }
//              else{
//                  audioPlayer.stop()
//                  sender.setTitle("Play", for: .normal)
//              }
//

    }
    
    @IBAction func record(_ sender: UIButton) {
        
            if sender.titleLabel?.text == "Record"{
                recorder.record()
                sender.setTitle("Stop", for: .normal)
                //playBtn.isEnabled = false
            }
            else{
                recorder.stop()
                sender.setTitle("Record", for: .normal)
                //playBtn.isEnabled = false
            }
        
    }
    
    func getCacheDirectory() -> URL {
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return docsurl
    }
    
    func getFileURL() -> URL{
        let path  = getCacheDirectory()
        let filePath = path.appendingPathComponent("\(fileName)")
        return filePath
    }
    
    
    
    func preparePlayer(){
        do {
            player =  try AVAudioPlayer(contentsOf: getFileURL())
            
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
        } catch {
            print("Audio Record Failed ")
        }
    }
    
    func startSession(){
        recordSession = AVAudioSession.sharedInstance()
        
        do {
            try recordSession.setCategory(AVAudioSession.Category.playAndRecord)
            try recordSession.setActive(true)
            recordSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.setupRecorder()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }

    func setupRecorder(){
    let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                          AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                          AVEncoderBitRateKey : 320000,
                          AVNumberOfChannelsKey : 2,
                          AVSampleRateKey : 44100.0 ] as [String : Any]
    do {
        recorder = try AVAudioRecorder(url: getFileURL(), settings: recordSettings)
        recorder.delegate = self
        recorder.prepareToRecord()
        //playBtn.isEnabled = false
    }
    catch {
        print("\(error)")
    }
    
}
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           // playBtn.isEnabled = true
        }
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           // recordBtn.isEnabled = true
           // playBtn.setTitle("Play", for: .normal)
        }
    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//            recordBtn.isEnabled = true
//            playBtn.setTitle("Play", for: .normal)
//        }
//
}




