//
//  RootViewController.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import UIKit

final class RootViewController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    
    let departments: [DepartmentModel] = [
      DepartmentModel(name: "Department 1", people: [
        PersonModel(name: "Person 1", salary: 100),
        PersonModel(name: "Person 2", salary: 200),
        PersonModel(name: "Person 3", salary: 300),
      ]),
      DepartmentModel(name: "Department 2", people: [
        PersonModel(name: "Person 4", salary: 400),
        PersonModel(name: "Person 5", salary: 500),
        PersonModel(name: "Person 6", salary: 600),
      ]),
    ]
    
    self.pushViewController(
      DepartmentsListView(viewModel: DepartmentsListViewModel(departments: departments)),
      animated: false)
  }
  
  // MARK: Public Methods
  
  func showDeparmentDetails(
    viewModel: DepartmentViewModel)
  {
    self.pushViewController(PeopleListView(viewModel: viewModel), animated: true)
  }
  
}

extension UIViewController {
  
  var router: RootViewController? {
    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    return appDelegate?.window?.rootViewController as? RootViewController
  }
  
}
