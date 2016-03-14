//
//  UITableViewCellViewModelProtocol.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import Foundation

import Bond

protocol UITableViewCellViewModelProtocol {
  
  var cellTitle: String    { get }
  var cellDetails: Observable<String?> { get }
  
}
