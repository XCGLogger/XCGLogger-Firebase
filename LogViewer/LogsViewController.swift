//
//  ViewController.swift
//  LogViewer
//
//  Created by Oleksii Shvachenko on 9/29/17.
//  Copyright © 2017 oleksii. All rights reserved.
//

import Cocoa

enum SelectedFilter: Int {
  case all
  case error
  case debug
  case severe
  case info
}

class LogCellView: NSTableCellView {
  @IBOutlet weak var fileLabel: NSTextField!
  @IBOutlet weak var lineLabel: NSTextField!
  @IBOutlet weak var functionLabel: NSTextField!
  @IBOutlet weak var messageLabel: NSTextField!
  @IBOutlet weak var dateLabel: NSTextField!
  @IBOutlet weak var severeView: NSBox!
}

class LogsViewController: NSViewController {

  @IBOutlet weak var tableView: NSTableView!
  var allLogs: [LogData] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  let dateFormatter = DateComponentsFormatter()
  var seletedFilter = SelectedFilter.all

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.usesAutomaticRowHeights = true

    dateFormatter.unitsStyle = .abbreviated
    dateFormatter.maximumUnitCount = 2
  }

  @IBAction func didSelelectValue(_ sender: NSPopUpButton) {
    let selectedIndex = sender.indexOfSelectedItem
    seletedFilter = SelectedFilter(rawValue: selectedIndex)!
    tableView.reloadData()
  }

  func logsAccordingToSelectedFilter() -> [LogData] {
    switch seletedFilter {
    case .all:
      return allLogs
    case .debug:
      return allLogs.filter { $0.level == .debug }
    case .error:
      return allLogs.filter { $0.level == .error }
    case .info:
      return allLogs.filter { $0.level == .info }
    case .severe:
      return allLogs.filter { $0.level == .severe }
    }
  }

}

extension LogsViewController: NSTableViewDataSource, NSTableViewDelegate {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return logsAccordingToSelectedFilter().count
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LogInfoCell"), owner: nil) as! LogCellView
    let logData = logsAccordingToSelectedFilter()[row]
    cell.fileLabel.stringValue = logData.fileName
    cell.lineLabel.stringValue = "line \(logData.lineNumber)"
    cell.functionLabel.stringValue = logData.functionName
    cell.messageLabel.stringValue = "Message: \(logData.message)"
    cell.dateLabel.stringValue = dateFormatter.string(from: logData.date, to: Date())!

    switch logData.level {
    case .debug:
      cell.severeView.fillColor = NSColor.brown
    case .error:
      cell.severeView.fillColor = NSColor.red
    case .info:
      cell.severeView.fillColor = NSColor.blue
    case .severe:
      cell.severeView.fillColor = NSColor.orange
    }
    return cell
  }
}

