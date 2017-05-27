//
//  MainVC.swift
//  Restaurant
//
//  Created by Vlad Krupenko on 24.05.17.
//  Copyright © 2017 Fixique. All rights reserved.
//

import Cocoa
import CoreData

class MainVC: NSViewController, NSComboBoxDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addBox: NSView!
    @IBOutlet weak var racesSelector: NSComboBox!
    @IBOutlet weak var jockeySelector: NSComboBox!
    @IBOutlet weak var horseSelector: NSComboBox!
    @IBOutlet weak var placeTextField: NSTextField!
    @IBOutlet weak var resultTimeTextField: NSTextField!
    @IBOutlet weak var addBtn: NSButton!
    @IBOutlet weak var delBtn: NSButton!
    

    var races: [Races]?
    var jockeys: [Jockey]?
    var horses: [Horse]?
    var results: [Results]?
    var currentUpdate: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        racesSelector.usesDataSource = true
        racesSelector.dataSource = self
        jockeySelector.usesDataSource = true
        jockeySelector.dataSource = self
        horseSelector.usesDataSource = true
        horseSelector.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
            
        getRaces()
        getJockeys()
        getHorses()
        getResults()
        
    }
    
    override func viewDidAppear() {
        
        addBox.layer?.borderWidth = 1.0
        addBox.layer?.borderColor = NSColor.lightGray.cgColor
        updateUI()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        guard placeTextField.stringValue != "" && resultTimeTextField.stringValue != "" else {return}
        
        var item: Results!
        
        if currentUpdate == nil {
            item = Results(context: context)
        } else {
            item = currentUpdate
        }
        
        item.place = Int16(placeTextField.stringValue)!
        item.resultTime = Double(resultTimeTextField.stringValue)!
        item.toRaces = races?[racesSelector.indexOfSelectedItem]
        item.toHorse = horses?[horseSelector.indexOfSelectedItem]
        item.toJockey = jockeys?[jockeySelector.indexOfSelectedItem]
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
        races?.removeAll()
        jockeys?.removeAll()
        horses?.removeAll()
        results?.removeAll()
        getRaces()
        getJockeys()
        getHorses()
        getResults()
        placeTextField.stringValue = ""
        resultTimeTextField.stringValue = ""
        addBtn.title = "Добавить"
        delBtn.isHidden = true
        currentUpdate = nil
    }
    
    func tableViewDoubleClick(_ sender: AnyObject) {
        guard tableView.selectedRow >= 0, let item = results?[tableView.selectedRow] else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        placeTextField.stringValue = String(item.place)
        resultTimeTextField.stringValue = String(item.resultTime)
        
        let raceId = races?.index(of: item.toRaces!)
        racesSelector.selectItem(at: raceId!)
        let jockeyId = jockeys?.index(of: item.toJockey!)
        jockeySelector.selectItem(at: jockeyId!)
        let horseId = horses?.index(of: item.toHorse!)
        horseSelector.selectItem(at: horseId!)
    
        addBtn.title = "Обновить"
        delBtn.isHidden = false
        currentUpdate = item
        
    }

    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if comboBox == racesSelector {
            return races?.count ?? 0
        } else if comboBox == jockeySelector {
            return jockeys?.count ?? 0
        } else if comboBox == horseSelector {
            return horses?.count ?? 0
        }
        
        return 0
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        
        if comboBox == racesSelector {
            return dateFormatter.string(from: (races?[index].dateRace)! as Date)
        } else if comboBox == jockeySelector {
            return jockeys?[index].fullName
        } else if comboBox == horseSelector {
            return horses?[index].nickName
        }
        
        return nil
    }
    
    func getRaces() {
        
        let fetchRequest: NSFetchRequest<Races> = Races.fetchRequest()
        
        do {
            self.races = try context.fetch(fetchRequest)
            racesSelector.reloadData()
        } catch {
            // handle error
        }
    }
    
    
    func getResults() {
        
        let fetchRequest: NSFetchRequest<Results> = Results.fetchRequest()
        
        do {
            self.results = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            // handle error
        }
    }
    
    func getHorses() {
        
        let fetchRequest: NSFetchRequest<Horse> = Horse.fetchRequest()
        
        do {
            self.horses = try context.fetch(fetchRequest)
            horseSelector.reloadData()
        } catch {
            // handle error
        }
    }
    
    func getJockeys() {
        let fetchRequest: NSFetchRequest<Jockey> = Jockey.fetchRequest()
        
        do {
            self.jockeys = try context.fetch(fetchRequest)
            jockeySelector.reloadData()
        } catch {
            // handle error
        }
    }
    
}

extension MainVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results?.count ?? 0
    }
}


extension MainVC: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let dateCell = "dateCellID"
        static let jockeyCell = "jockeyCellID"
        static let horseCell = "horseCellID"
        static let placeCell = "placeCellID"
        static let timeCell = "timeCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let item = results?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = dateFormatter.string(from: item.toRaces!.dateRace! as Date)
            cellIdentifier = CellIdentifiers.dateCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.toJockey!.fullName!
            cellIdentifier = CellIdentifiers.jockeyCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.toHorse!.nickName!
            cellIdentifier = CellIdentifiers.horseCell
        } else if tableColumn == tableView.tableColumns[3] {
            text = String(item.place)
            cellIdentifier = CellIdentifiers.placeCell
        } else if tableColumn == tableView.tableColumns[4] {
            text = String(item.resultTime)
            cellIdentifier = CellIdentifiers.timeCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}


