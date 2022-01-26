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
    @IBOutlet weak var voiceNoteBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate:NotesViewProtocol?
    @IBOutlet weak var attachImgBtn: UIButton!
    @IBOutlet weak var SaveBtn: UIButton!
    @IBOutlet weak var notesDetailedView: UITextView!
    @IBOutlet weak var titleNameField: UITextField!
    @IBOutlet weak var markCompleteBtn: UIButton!
    var imagePicker = UIImagePickerController()
    var savedNote:Note?
    var images = [Image]()
    let rows = 1
    let columnsInPage = 3
    var itemsInPage: Int { return columnsInPage*rows }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        notesDetailedView.text = "Task Description"
        notesDetailedView.textColor = UIColor.lightGray
        collectionView?.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let note = savedNote else {
            markCompleteBtn.isEnabled = false
            return
        }
        voiceNoteBtn.isEnabled = !note.status
        markCompleteBtn.isEnabled = !note.status
        SaveBtn.isEnabled = !note.status
        attachImgBtn.isEnabled = !note.status
        titleNameField.text = note.title
        notesDetailedView.text = note.detail
        if let noteimages = note.images?.allObjects as? [Image] {
            images = noteimages
         }
        notesDetailedView.textColor = UIColor.black
    }
    
    @IBAction func markComplete(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure  you want to mark this complete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
            self.markComplete()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func markComplete() {
        if let note = savedNote {
            do {
                let myNotes = try PersistentStorage.shared.context.fetch(Note.fetchRequest())
                guard let editedNote = myNotes.first(where: {$0.objectID == note.objectID}) else {return}
                editedNote.status = true
                PersistentStorage.shared.saveContext()
                self.dismiss(animated: true, completion: nil)
                delegate?.didSaveNote()
            } catch let error {
                print(error)
            }
        }
    }
    
    @IBAction func voiceNoteBtnAction(_ sender: Any) {
        
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
            showAlert(message: "Please Enter Task Title")
        } else if let detail = notesDetailedView.text, detail.isEmpty {
            showAlert(message: "Please Enter Task Description")
        } else {
            
            if let note = savedNote {
                do {
                    let myNotes = try PersistentStorage.shared.context.fetch(Note.fetchRequest())
                    guard let editedNote = myNotes.first(where: {$0.objectID == note.objectID}) else {return}
                    editedNote.title = titleNameField.text
                    editedNote.detail = notesDetailedView.text
                    editedNote.images = Set(images) as NSSet
                } catch let error {
                    print(error)
                }
            } else {
                let note = Note(context: PersistentStorage.shared.context)
                note.title = titleNameField.text
                note.detail = notesDetailedView.text
                note.images = Set(images) as NSSet
                note.date = Date()
            }
            PersistentStorage.shared.saveContext()
            self.dismiss(animated: true, completion: nil)
            delegate?.didSaveNote()
        }
    }
    
    
    
    @IBAction func addRecording(_ sender: UIButton) {
        
        
        
        
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
            textView.text = "Task Description"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension NotesViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let noteImage  = Image(context: PersistentStorage.shared.context)
            noteImage.noteImage = image.pngData()
            images.append(noteImage)
            collectionView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
}


extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? ImageCollectionViewCell {
            let t = indexPath.item / itemsInPage
            let i = indexPath.item / rows - t*columnsInPage
            let j = indexPath.item % rows
            let item = (j*columnsInPage+i) + t*itemsInPage
            
            guard item < images.count else {
                cell.isHidden = true
                return cell
            }
            cell.isHidden = false
            let image = images[indexPath.row]
            if let imageData = image.noteImage {
                cell.imageView.image = UIImage(data:imageData,scale:0.1)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 100
        let cellHeight = 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        if let imageData = image.noteImage, let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "PoppverController") as? PoppverController {
            popupViewController.image = UIImage(data:imageData,scale:0.75)
            popupViewController.modalPresentationStyle = .popover
            present(popupViewController, animated: true, completion:nil)
        }
    }
}
