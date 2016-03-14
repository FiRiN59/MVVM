//
//  DepartmentsListView.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import UIKit

import Bond

final class DepartmentsListView: UITableViewController, BNDTableViewProxyDataSource {
  
  private struct ReuseIdentifiers {
    static let DepartmentListItem = "DepartmentsListItemView"
  }
  
  private let viewModel: DepartmentsListViewModel
  
  required init(
    viewModel: DepartmentsListViewModel)
  {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    self.viewModel.departmens
      .lift()
      .bindTo(self.tableView, proxyDataSource: self) { indexPath, dataSource, tableView in
        let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifiers.DepartmentListItem)
        let cell = dequeuedCell as? UITableViewCellView
          ?? UITableViewCellView(style: .Subtitle, reuseIdentifier: ReuseIdentifiers.DepartmentListItem)
        
        cell.viewModel = dataSource[indexPath.section][indexPath.row]
        cell.accessoryType = .DisclosureIndicator

        return cell
      }
  }

  required init?(
    coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    self.title = self.viewModel.title
    self.tableView.tableFooterView = UIView()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDepartment")
  }
  
  // MARK: Private Methods
  
  // NOTE: Used as a selector above
  func addDepartment() {
    let alert = UIAlertController(title: "Add Department", message: nil, preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { [weak alert] _ in
      guard let name = alert?.textFields?.first?.text else {
        return
      }
      self.viewModel.departmens.append(DepartmentViewModel(department: DepartmentModel(name: name, people: [])))
    }
    
    alert.addAction(okAction)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    
    alert.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Name"
      textField.bnd_text
        .map { ($0?.characters.count ?? 0) > 0 }
        .observe { okAction.enabled = $0 }
        .disposeIn(textField.bnd_bag)
    }
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(
    tableView: UITableView,
    canEditRowAtIndexPath indexPath: NSIndexPath)
    -> Bool
  {
    return true
  }
  
  override func tableView(
    tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath)
  {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      self.viewModel.departmens.removeAtIndex(indexPath.row)
    }
  }
  
  override func tableView(
    tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    self.router?.showDeparmentDetails(self.viewModel.departmens[indexPath.row])
  }
  
}
