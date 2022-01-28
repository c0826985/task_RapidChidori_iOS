//
//  AudioViewController.swift
//  task_RapidChidori_iOS
//
//  Created by Kaushil Prajapati on 26/01/22.
//

import UIKit
import AVFoundation
import CoreData

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startSession()
        play.isEnabled = false
    }
    
   
    var fileName : String!
    var counter = 0
    var finalTitle : String!
    var savedNote:Note?
    var finalNotes : String!
    var delegate:NotesViewProtocol?
    var sounds = [Audio]()
    
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
        counter += 1
        //if let title = finalTitle, title.isEmpty {
          //  showAlert(message: "Please Go back and enter a Task Title")
        //}
        
       // else if let detail = finalNotes, detail.isEmpty {
           // showAlert(message: "Please Go back and enter a Task Description")
   // }
        //else{
            
          //  if let note = savedNote {
               // do {
                  //  let myNotes = try PersistentStorage.shared.context.fetch(Note.fetchRequest())
                   // guard let editedNote = myNotes.first(where: {$0.objectID == note.objectID}) else{return}
                    //editedNote.title = finalTitle
                    //editedNote.detail = finalNotes
                   // editedNote.sounds = Set(sounds) as NSSet
                  fileName = "audio_file" + String(counter) + ".m4a"
             //   } catch let error {
                 //   print(error)
              //  }
     //   }   else{
       //     let note = Note(context: PersistentStorage.shared.context)
            //note.title = finalTitle
            //note.detail = finalNotes
           // note.sounds = Set(sounds) as NSSet
            //note.date = Date()
       // }
         //   PersistentStorage.shared.saveContext()
        //    self.dismiss(animated: true, completion: nil)
         //   delegate?.didSaveNote()
         //   fileName = "audio_file" + String(counter) + "m4a"
      //  performSegue(withIdentifier: "saveAudio", sender: self)
}

  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     //   let vc = segue.destination as! NotesViewController
          //  vc.audioFile = fileName
      //  vc.= self.finalTitle
      //  vc.= self.finalNotes
    //}

   // func showAlert(message: String) {
      //  let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
      //  alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      //  self.present(alert, animated: true, completion: nil)
    //}
}

