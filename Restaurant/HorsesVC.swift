//
//  HorsesVC.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Cocoa

class HorsesVC: NSViewController, NSComboBoxDataSource {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var nicknameTextField: NSTextField!
    @IBOutlet weak var genderSelectors: NSComboBox!
    @IBOutlet weak var ageTextField: NSTextField!
    @IBOutlet weak var ownersSelector: NSComboBox!
    @IBOutlet weak var addBtn: NSButton!
    @IBOutlet weak var delBtn: NSButton!
    @IBOutlet weak var addBox: NSView!
    
    
    var owners: [Owner]?
    var horses: [Horse]?
    var currentUpdate: Horse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownersSelector.usesDataSource = true
        ownersSelector.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        getOwners()
        getHorses()
        //ownersSelector.indexOfSelectedItem

    }
    
    override func viewDidAppear() {
        
        addBox.layer?.borderWidth = 1.0
        addBox.layer?.borderColor = NSColor.lightGray.cgColor
        updateUI()
    }


    
    @IBAction func addBtnPressed(_ sender: Any) {
        guard nicknameTextField.stringValue != "" && ageTextField.stringValue != "" else {return}
        
        var item: Horse!
        
        if currentUpdate == nil {
            item = Horse(context: context)
        } else {
            item = currentUpdate
        }
        
        
        item.nickName = nicknameTextField.stringValue
        item.age = Int16(ageTextField.stringValue)!
        item.gender = genderSelectors.objectValueOfSelectedItem as? String
        item.toOwner = owners?[ownersSelector.indexOfSelectedItem]
        updateUI()
    }
    
    @IBAction func delBtnPressed(_ sender: Any) {
        guard let item = currentUpdate else {
            return
        }
        
        context.delete(item)
        updateUI()
    }
    
    func updateUI() {
        ad.saveAction(nil)
        owners?.removeAll()
        getOwners()
        horses?.removeAll()
        getHorses()
        nicknameTextField.stringValue = ""
        ageTextField.stringValue = ""
        addBtn.title = "Добавить"
        delBtn.isHidden = true
        currentUpdate = nil
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return owners?.count ?? 0
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return owners?[index].fullName
    }
    
    func tableViewDoubleClick(_ sender: AnyObject) {
        guard tableView.selectedRow >= 0, let item = horses?[tableView.selectedRow] else {
            return
        }
        
        
        nicknameTextField.stringValue = item.nickName!
        ageTextField.stringValue = String(item.age)
        
        if item.gender == "Famale" {
            genderSelectors.selectItem(at: 1)
        } else {
            genderSelectors.selectItem(at: 0)
        }
        
        let ownerID = owners?.index(of: item.toOwner!)
        ownersSelector.selectItem(at: ownerID!)
        
        addBtn.title = "Обновить"
        delBtn.isHidden = false
        currentUpdate = item
        
    }

    
    
    func getOwners() {
        
        let fetchRequest: NSFetchRequest<Owner> = Owner.fetchRequest()
        
        do {
            self.owners = try context.fetch(fetchRequest)
            ownersSelector.reloadData()
        } catch {
            // handle error
        }
    }
    
    func getHorses() {
        
        let fetchRequest: NSFetchRequest<Horse> = Horse.fetchRequest()
        
        do {
            self.horses = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            // handle error
        }
    }

}

extension HorsesVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return horses?.count ?? 0
    }
}


extension HorsesVC: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let nicknameCell = "nicknameCellID"
        static let genderCell = "genderCellID"
        static let ageCell = "ageCellID"
        static let ownerCell = "ownerCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let item = horses?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.nickName ?? "Пусто"
            cellIdentifier = CellIdentifiers.nicknameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.gender ?? "Пусто"
            cellIdentifier = CellIdentifiers.genderCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = String(item.age)
            cellIdentifier = CellIdentifiers.ageCell
        } else if tableColumn == tableView.tableColumns[3] {
            text = item.toOwner!.fullName!
            cellIdentifier = CellIdentifiers.ownerCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}

