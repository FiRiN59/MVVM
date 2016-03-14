//
//  PeopleListView.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import UIKit

import Bond

final class PeopleListView: UITableViewController, BNDTableViewProxyDataSource {
  
  private struct ReuseIdentifiers {
    static let DepartmentListItem = "PeopleListViewItemView"
  }
  
  private let viewModel: DepartmentViewModel
  
  required init(
    viewModel: DepartmentViewModel)
  {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    self.viewModel.people
      .lift()
      .bindTo(self.tableView, proxyDataSource: self) { indexPath, dataSource, tableView in
        let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifiers.DepartmentListItem)
        let cell = dequeuedCell as? UITableViewCellView
          ?? UITableViewCellView(style: .Value1, reuseIdentifier: ReuseIdentifiers.DepartmentListItem)
        
        cell.viewModel = dataSource[indexPath.section][indexPath.row]
        cell.selectionStyle = .None
        
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
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPerson")
  }
  
  // MARK: Private Methods
  
  // NOTE: Used as a selector above
  func addPerson() {
    let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { [weak alert] _ in
      guard let name = alert?.textFields?.first?.text else {
        return
      }
      let salary = Float(alert?.textFields?.last?.text ?? "0") ?? 0
      self.viewModel.people.append(PersonViewModel(person: PersonModel(name: name, salary: salary)))
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

    alert.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Salary"
      textField.keyboardType = .NumberPad
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
      self.viewModel.people.removeAtIndex(indexPath.row)
    }
  }
  
  override func tableView(
    tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    let person = self.viewModel.people[indexPath.row]
    
    let alert = UIAlertController(title: "Edit Person", message: nil, preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { [weak alert] _ in
      guard let name = alert?.textFields?.first?.text else {
        return
      }
      let salary = Float(alert?.textFields?.last?.text ?? "0") ?? 0
      self.viewModel.people[indexPath.row] = (PersonViewModel(person: PersonModel(name: name, salary: salary)))
    }
    
    alert.addAction(okAction)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    
    alert.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Name"
      textField.text = person.name
      textField.bnd_text
        .map { ($0?.characters.count ?? 0) > 0 }
        .observe { okAction.enabled = $0 }
        .disposeIn(textField.bnd_bag)
    }
    
    alert.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Salary"
      textField.text = String(Int(person.salary))
      textField.keyboardType = .NumberPad
    }
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
}
