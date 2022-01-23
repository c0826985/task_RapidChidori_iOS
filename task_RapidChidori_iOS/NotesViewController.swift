//
//  NotesViewController.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 20/01/22.
//

import UIKit
import CoreData
import Photos

protocol NotesViewProtocol {
    func didSaveNote()
}

class NotesViewController: UIViewController {
    var delegate:NotesViewProtocol?
    @IBOutlet weak var myNoteImage: UIImageView!
    @IBOutlet weak var notesDetailedView: UITextView!
    @IBOutlet weak var titleNameField: UITextField!
    var imagePicker = UIImagePickerController()
    var savedNote:Note?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        notesDetailedView.text = "Note Details"
        notesDetailedView.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let note = savedNote else {return}
        titleNameField.text = note.title
        notesDetailedView.text = note.detail
        notesDetailedView.textColor = UIColor.black
    }
    
    @IBAction func attachImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if let title = titleNameField.text, title.isEmpty {
            showAlert(message: "Please Enter Note Title")
        } else if let detail = notesDetailedView.text, detail.isEmpty {
            showAlert(message: "Please Enter Notes Description")
        } else {
            
            if let note = savedNote {
                do {
                    let myNotes = try PersistentStorage.shared.context.fetch(Note.fetchRequest())
                    guard let editedNote = myNotes.first(where: {$0.objectID == note.objectID}) else {return}
                    editedNote.title = titleNameField.text
                    editedNote.detail = notesDetailedView.text
                } catch let error {
                    print(error)
                }
            } else {
                let note  = Note(context: PersistentStorage.shared.context)
                note.title = titleNameField.text
                note.detail = notesDetailedView.text
                note.date = Date()
            }
            PersistentStorage.shared.saveContext()
            self.dismiss(animated: true, completion: nil)
            delegate?.didSaveNote()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension NotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension NotesViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myNoteImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}

