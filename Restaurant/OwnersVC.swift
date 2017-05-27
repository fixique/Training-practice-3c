//
//  OwnersVC.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 26.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Cocoa
import CoreData

class OwnersVC: NSViewController {

    @IBOutlet weak var addBox: NSView!
    @IBOutlet weak var fullNameTextField: NSTextField!
    @IBOutlet weak var passportTextField: NSTextField!
    @IBOutlet weak var addressTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var delBtn: NSButton!
    
    var owners: [Owner]?
    var currentUpdate: Owner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        getOwners()
    }
    
    override func viewDidAppear() {
        
        addBox.layer?.borderWidth = 1.0
        addBox.layer?.borderColor = NSColor.lightGray.cgColor
        updateUI()
    }
    
    func tableViewDoubleClick(_ sender: AnyObject) {
        guard tableView.selectedRow >= 0, let item = owners?[tableView.selectedRow] else {
            return
        }
        
        fullNameTextField.stringValue = item.fullName!
        passportTextField.stringValue = item.passportNumber!
        addressTextField.stringValue = item.address!
        addButton.title = "Обновить"
        delBtn.isHidden = false
        currentUpdate = item
        
    }
    
    @IBAction func addToDBPressed(_ sender: Any) {
        
        guard fullNameTextField.stringValue != "" &&
            addressTextField.stringValue != "" &&
            passportTextField.stringValue != ""
            else { return }
        
        var item: Owner!
        
        if currentUpdate == nil {
            item = Owner(context: context)
        } else {
            item = currentUpdate
        }
        
        item.fullName = fullNameTextField.stringValue
        item.address = addressTextField.stringValue
        item.passportNumber = passportTextField.stringValue
        updateUI()
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        guard let item = currentUpdate else {
            return
        }
        
        context.delete(item)
        updateUI()
    }
    
    func updateUI() {
        ad.saveAction(nil)
        getOwners()
        fullNameTextField.stringValue = ""
        passportTextField.stringValue = ""
        addressTextField.stringValue = ""
        addButton.title = "Добавить"
        delBtn.isHidden = true
        currentUpdate = nil

    }
    
    func getOwners() {
        
        let fetchRequest: NSFetchRequest<Owner> = Owner.fetchRequest()
        
        do {
            self.owners = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            // handle error
        }
    }

    
}

extension OwnersVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return owners?.count ?? 0
    }
}

extension OwnersVC: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let fullNameCell = "fullNameCellID"
        static let passportCell = "passportCellID"
        static let addressCell = "addressCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let item = owners?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.fullName ?? "Пусто"
            cellIdentifier = CellIdentifiers.fullNameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.passportNumber ?? "Пусто"
            cellIdentifier = CellIdentifiers.passportCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.address ?? "Пусто"
            cellIdentifier = CellIdentifiers.addressCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}
