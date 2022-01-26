//
//  ViewController.swift
//  task_RapidChidori_iOS
//
//  Created by Kaushil Prajapati on 13/01/22.
//

import UIKit


class LandingViewController: UIViewController,NotesViewProtocol {
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var sortByBtn: UIButton!
    var notesArray = [Note]()
    var filteredNotesArray = [Note]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noNotesLbl: UILabel!
    var selectedNote:Note?
    var isTyping: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadTable()
        loadAddNoteButton()
    }
    
    func loadAddNoteButton() {
        let floatingButton = UIButton()
        floatingButton.setTitle("Add", for: .normal)
        floatingButton.tag = 101
        floatingButton.backgroundColor = .cyan
        floatingButton.layer.cornerRadius = 25
        floatingButton.setImage(UIImage(named: "add"), for: .normal)
        floatingButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc func addTapped(_ button: UIButton) {
        searchbar.resignFirstResponder()
        let notesViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        notesViewController.savedNote = (button.tag == 101) ? nil : selectedNote
        notesViewController.delegate = self
        self.present(notesViewController, animated: true)
    }
    
    func loadData() {
        do {
            let myNotes = try PersistentStorage.shared.context.fetch(Note.fetchRequest())
            notesArray.removeAll()
            notesArray.append(contentsOf: myNotes)
            filteredNotesArray = notesArray
            noNotesLbl.isHidden = !notesArray.isEmpty
        } catch let error {
            print(error)
        }
    }
    
    func loadTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(MyNotesTableViewCell.nib, forCellReuseIdentifier: MyNotesTableViewCell.reuseIdentifier)
    }
    
    @IBAction func sortbyFilterAction(_ sender: Any) {
        searchbar.resignFirstResponder()
        guard !notesArray.isEmpty else {
            showAlert(message: "No Tasks Available")
            return
        }
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Sort by A-Z", style: .default) { action -> Void in
            self.notesArray = self.notesArray.sorted(by: {$0.title! < $1.title!})
            self.tableView.reloadData()
            self.sortByBtn.setTitle("Sorted by A-Z", for: .normal)
            
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Sort by Date Added", style: .default) { action -> Void in
            self.notesArray = self.notesArray.sorted(by: {$0.date! < $1.date!})
            self.tableView.reloadData()
            self.sortByBtn.setTitle("Sorted by Date", for: .normal)
        }
        
        let clearFiltersAction: UIAlertAction = UIAlertAction(title: "Clear Filter", style: .default) { action -> Void in
            self.notesArray = self.filteredNotesArray
            self.tableView.reloadData()
            self.sortByBtn.setTitle("Sort by", for: .normal)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(clearFiltersAction)
        actionSheetController.addAction(cancelAction)
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didSaveNote() {
        selectedNote = nil
        loadData()
        tableView.reloadData()
    }
}

extension LandingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MyNotesTableViewCell.reuseIdentifier) as? MyNotesTableViewCell{
            cell.bgView.backgroundColor = (notesArray[indexPath.row].status == true) ? .lightGray : .white
            cell.titleLbl.text = notesArray[indexPath.row].title
            cell.descriptionLbl.text = notesArray[indexPath.row].detail
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notesArray[indexPath.row]
        addTapped(UIButton())
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            PersistentStorage.shared.context.delete(notesArray[indexPath.row])
            PersistentStorage.shared.saveContext()
            loadData()
            tableView.reloadData()
        }
    }
}

extension LandingViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        notesArray = searchText.isEmpty ? filteredNotesArray : filteredNotesArray.filter({ note in
            return (note.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) || (note.detail?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        notesArray = filteredNotesArray
        tableView.reloadData()
    }
}
