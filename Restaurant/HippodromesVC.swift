//
//  HippodromesVC.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Cocoa
import CoreData

class HippodromesVC: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addBox: NSView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var addressTextField: NSTextField!
    @IBOutlet weak var addBtn: NSButton!
    @IBOutlet weak var delBtn: NSButton!
    
    var hippodromes: [Hippodrome]?
    var currentUpdate: Hippodrome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor

        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))

        
        getHippodromes()
    }
    
    override func viewDidAppear() {
        
        addBox.layer?.borderWidth = 1.0
        addBox.layer?.borderColor = NSColor.lightGray.cgColor
        updateUI()
    }

    func tableViewDoubleClick(_ sender: AnyObject) {
        guard tableView.selectedRow >= 0, let item = hippodromes?[tableView.selectedRow] else {
            return
        }
        
        titleTextField.stringValue = item.name!
        addressTextField.stringValue = item.address!
        addBtn.title = "Обновить"
        delBtn.isHidden = false
        currentUpdate = item
        
    }

    
    @IBAction func addBtnPressed(_ sender: Any) {
        guard titleTextField.stringValue != "" &&
            addressTextField.stringValue != ""
            else { return }
        
        var item: Hippodrome!
        
        if currentUpdate == nil {
            item = Hippodrome(context: context)
        } else {
            item = currentUpdate
        }
        
        item.name = titleTextField.stringValue
        item.address = addressTextField.stringValue
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
        hippodromes?.removeAll()
        getHippodromes()
        titleTextField.stringValue = ""
        addressTextField.stringValue = ""
        addBtn.title = "Добавить"
        delBtn.isHidden = true
        currentUpdate = nil
    }
    
    func getHippodromes() {
        let fetchRequest: NSFetchRequest<Hippodrome> = Hippodrome.fetchRequest()
        
        do {
            self.hippodromes = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            // handle errors
        }
    }
}

extension HippodromesVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return hippodromes?.count ?? 0
    }
}

extension HippodromesVC: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let titleCell = "nameCellID"
        static let addressCell = "addressCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let item = hippodromes?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.name!
            cellIdentifier = CellIdentifiers.titleCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.address!
            cellIdentifier = CellIdentifiers.addressCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}
