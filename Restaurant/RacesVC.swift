//
//  RacesVC.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 27.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Cocoa
import CoreData

class RacesVC: NSViewController, NSComboBoxDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addBox: NSView!
    @IBOutlet weak var dateTextField: NSTextField!
    @IBOutlet weak var hippodromeSelector: NSComboBox!
    @IBOutlet weak var addBtn: NSButton!
    @IBOutlet weak var delBtn: NSButton!
    
    var hippodromes: [Hippodrome]?
    var races: [Races]?
    var currentUpdate: Races?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor

        hippodromeSelector.usesDataSource = true
        hippodromeSelector.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        getHippodromes()
        getRaces()
    }
    
    override func viewDidAppear() {
        
        addBox.layer?.borderWidth = 1.0
        addBox.layer?.borderColor = NSColor.lightGray.cgColor
        updateUI()
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return hippodromes?.count ?? 0
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return hippodromes?[index].name
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        guard dateTextField.stringValue != "" else {return}
        
        var item: Races!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentUpdate == nil {
            item = Races(context: context)
        } else {
            item = currentUpdate
        }
        
        item.dateRace = dateFormatter.date(from: dateTextField.stringValue)! as NSDate
        item.toHippodrome = hippodromes?[hippodromeSelector.indexOfSelectedItem]
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
        races?.removeAll()
        getHippodromes()
        getRaces()
        dateTextField.stringValue = ""
        addBtn.title = "Добавить"
        delBtn.isHidden = true
        currentUpdate = nil
    }
    
    func tableViewDoubleClick(_ sender: AnyObject) {
        guard tableView.selectedRow >= 0, let item = races?[tableView.selectedRow] else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateTextField.stringValue = dateFormatter.string(from: item.dateRace! as Date)
        
        let hippodromeID = hippodromes?.index(of: item.toHippodrome!)
        hippodromeSelector.selectItem(at: hippodromeID!)
        
        addBtn.title = "Обновить"
        delBtn.isHidden = false
        currentUpdate = item
        
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

    func getRaces() {
        let fetchRequest: NSFetchRequest<Races> = Races.fetchRequest()
        
        do {
            self.races = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            // handle errors
        }
    }

    
}

extension RacesVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return races?.count ?? 0
    }
}


extension RacesVC: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let dateCell = "dateCellID"
        static let hippodromeCell = "hippodromeCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let item = races?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = dateFormatter.string(from: item.dateRace! as Date)
            cellIdentifier = CellIdentifiers.dateCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.toHippodrome!.name!
            cellIdentifier = CellIdentifiers.hippodromeCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}


