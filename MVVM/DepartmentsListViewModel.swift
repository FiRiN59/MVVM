//
//  DepartmentsListViewModel.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import Foundation

import Bond

final class DepartmentsListViewModel {
  
  let model: [DepartmentModel]
  
  let title: String
  let departmens = ObservableArray<DepartmentViewModel>([])
  
  init(
    departments: [DepartmentModel])
  {
    self.model = departments
    self.title = "Departments"
    self.departmens.array = departments.map { DepartmentViewModel(department: $0) }
  }
  
}
