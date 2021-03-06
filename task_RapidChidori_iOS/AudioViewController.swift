//
//  AudioViewController.swift
//  task_RapidChidori_iOS
//
//  Created by Kaushil Prajapati on 26/01/22.
//

import UIKit
import AVFoundation
import CoreData

protocol AudioViewControllerProtocol {
    func didSaveMyAudioInNote(audio: Data?)
}

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var delegate: AudioViewControllerProtocol?
    var hasAudioSaved = false
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hasAudioSaved = UIApplication.shared.canOpenURL(getFileURL())
        self.startSession()
        play.isEnabled = hasAudioSaved
    }

    var fileName  = "myRecording.m4a"
    var counter = 0
    
    var recorder : AVAudioRecorder!
    var player : AVAudioPlayer!
    var recordSession : AVAudioSession!
    
    @IBOutlet weak var recordBtn: UIButton!
    
    
    @IBOutlet weak var play: UIButton!
    
    @IBAction func record(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Record"{
            recorder.record()
            sender.setTitle("Stop", for: .normal)
            play.isEnabled = false
        }
        else{
            recorder.stop()
            sender.setTitle("Record", for: .normal)
            play.isEnabled = false
        }
        
    }
    
    
    @IBAction func PlayRecordedAudio(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Play" {
            recordBtn.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            preparePlayer()
            player.play()
        }
        else{
            player.stop()
            sender.setTitle("Play", for: .normal)
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
        print(filePath)
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
            play.isEnabled = false
        }
        catch {
            print("\(error)")
        }
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        play.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        play.setTitle("Play", for: .normal)
    }
    
    
    @IBAction func save(_ sender: Any) {
        do {
            let audioData = try Data(contentsOf: getFileURL())
            self.delegate?.didSaveMyAudioInNote(audio: audioData)
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}

