//
//  UITableViewCellView.swift
//  MVVM
//
//  Created by Sergey Shavrin on 13/03/16.
//  Copyright © 2016 Glovo. All rights reserved.
//

import UIKit

import Bond

final class UITableViewCellView: UITableViewCell {
  
  private let reuseBag = DisposeBag()
  
  var viewModel: UITableViewCellViewModelProtocol? {
    didSet {
      self.textLabel?.text = self.viewModel?.cellTitle

      self.viewModel?.cellDetails
        .observe { [weak self] in self?.detailTextLabel?.text = $0 }
        .disposeIn(self.reuseBag)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.reuseBag.dispose()
    self.viewModel = nil
  }
  
}
