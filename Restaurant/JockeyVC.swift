//
//  JockeyVC.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Cocoa
import CoreData

class JockeyVC: NSViewController {
    
    @IBOutlet weak var fullNameTextField: NSTextField!
    @IBOutlet weak var ageTextField: NSTextField!
    @IBOutlet weak var ratingTextField: NSTextField!
    @IBOutlet weak var addBtn: NSButton!
    @IBOutlet weak var delBtn: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addBox: NSView!
    
    var jockeys: [Jockey]?
    var currentUpdate: Jockey?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        getJockey()
    }
    
    override func viewDidAppear() {
        
        addBox.layer?.borderWidth = 1.0
        addBox.layer?.borderColor = NSColor.lightGray.cgColor
        updateUI()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        guard fullNameTextField.stringValue != "" && ageTextField.stringValue != "" && ratingTextField.stringValue != "" else {return}
        
        var item: Jockey!
        
        if currentUpdate == nil {
            item = Jockey(context: context)
        } else {
            item = currentUpdate
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        item.fullName = fullNameTextField.stringValue
        item.rating = Double(ratingTextField.stringValue)!
        item.birthDate = dateFormatter.date(from: ageTextField.stringValue)! as NSDate
        updateUI()
        
    }
    
    @IBAction func delBtnPressed(_ sender: Any) {
        guard let item = currentUpdate else {
            return
        }
        
        context.delete(item)
        updateUI()

    }
    
    func tableViewDoubleClick(_ sender: AnyObject) {
        guard tableView.selectedRow >= 0, let item = jockeys?[tableView.selectedRow] else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        
        fullNameTextField.stringValue = item.fullName!
        ageTextField.stringValue = dateFormatter.string(from: item.birthDate! as Date)
        ratingTextField.stringValue = String(item.rating)
        addBtn.title = "Обновить"
        delBtn.isHidden = false
        currentUpdate = item

    }
    
    func updateUI() {
        ad.saveAction(nil)
        jockeys?.removeAll()
        getJockey()
        fullNameTextField.stringValue = ""
        ageTextField.stringValue = ""
        ratingTextField.stringValue = ""
        addBtn.title = "Добавить"
        delBtn.isHidden = true
        currentUpdate = nil
    }
    
    func getJockey() {
        
        let fetchRequest: NSFetchRequest<Jockey> = Jockey.fetchRequest()
        
        do {
            self.jockeys = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            // handle error
        }
    }
    
}

extension JockeyVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return jockeys?.count ?? 0
    }
}

extension JockeyVC: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let fullNameCell = "fullNameCellID"
        static let ageCell = "ageCellID"
        static let ratingCell = "ratingCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let item = jockeys?[row] else {
            return nil
        }
    
        if tableColumn == tableView.tableColumns[0] {
            text = item.fullName ?? "Пусто"
            cellIdentifier = CellIdentifiers.fullNameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.birthDate! as Date)
            cellIdentifier = CellIdentifiers.ageCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = String(item.rating)
            cellIdentifier = CellIdentifiers.ratingCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}
