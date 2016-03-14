//
//  DepartmentViewModel.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import Foundation

import Bond

final class DepartmentViewModel: UITableViewCellViewModelProtocol {
  
  let title: String
  let name: String
  let people = ObservableArray<PersonViewModel>([])
  
  let cellTitle: String
  let cellDetails = Observable<String?>(nil)
  
  private let bnd_bag = DisposeBag()
  
  init(
    department: DepartmentModel)
  {
    self.title = department.name
    self.name = department.name
    self.people.array = department.people.map { PersonViewModel(person: $0) }
    
    self.cellTitle = department.name

    self.people
      .observe { event in
        let count  = event.sequence.count
        let salary = event.sequence
          .map { $0.salary }
          .reduce(0.0) { $0 + $1 }
        self.cellDetails.next(String(format: "People: %i, Total Salary: %.02f €", count, salary))
      }
      .disposeIn(self.bnd_bag)
  }
  
  deinit {
    self.bnd_bag.dispose()
  }
  
}
