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
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate:NotesViewProtocol?
    @IBOutlet weak var notesDetailedView: UITextView!
    @IBOutlet weak var titleNameField: UITextField!
    var imagePicker = UIImagePickerController()
    var savedNote:Note?
    var images = [Image]()
    
    private let _numberOfColumn: CGFloat = 3.0
    private let _minimumInteritemSpacing: CGFloat = 8.0
    private let _minimumLineSpacing: CGFloat = 9.0
    private let _periodCellHeight: CGFloat = 32.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        notesDetailedView.text = "Note Details"
        notesDetailedView.textColor = UIColor.lightGray
        collectionView?.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let note = savedNote else {return}
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
                note.images = Set(images) as NSSet
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
            let noteImage  = Image(context: PersistentStorage.shared.context)
            noteImage.noteImage = image.pngData()
            images.append(noteImage)
            collectionView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//
//extension NotesViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
//                                                         for: indexPath) as? ImageCollectionViewCell {
//            let image = images[indexPath.row]
//            if let imageData = image.noteImage {
//                cell.imageView.image = UIImage(data:imageData,scale:0.5)
//            }
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//}
//
//extension NotesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let cell: ImageCollectionViewCell = Bundle.main.loadNibNamed(ImageCollectionViewCell.reuseIdentifier,
//                                                                      owner: self,
//                                                                      options: nil)?.first as? ImageCollectionViewCell else {
//            return CGSize.zero
//        }
////        cell.configureCell(name: images[indexPath.row])
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        return CGSize(width: size.width, height: 30)
//    }
//}

extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self._minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self._minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        var space: CGFloat = (flowayout?.minimumInteritemSpacing ?? self._minimumInteritemSpacing) * (self._numberOfColumn - 1)
        space += (flowayout?.sectionInset.left ?? 16.0) + (flowayout?.sectionInset.right ?? 16.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / self._numberOfColumn
        return CGSize(width: size, height: _periodCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let image = images[indexPath.row]
        if let imageData = image.noteImage {
            cell.imageView.image = UIImage(data:imageData,scale:0.5)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

