//
//  PersonViewModel.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import Foundation

import Bond

final class PersonViewModel: UITableViewCellViewModelProtocol {
  
  let title: String
  
  let name: String
  let salary: Float
  
  let cellTitle: String
  let cellDetails = Observable<String?>(nil)
  
  init(
    person: PersonModel)
  {
    self.title = person.name
    self.name  = person.name
    self.salary = person.salary
    
    self.cellTitle = self.title
    self.cellDetails.next(String(format: "%.02f €", person.salary))
  }
  
}
