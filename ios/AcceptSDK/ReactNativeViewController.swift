//
//  ReactNativeViewController.swift
//  AcceptSDK
//
//  Created by Madhavi  Solanki on 26/06/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

// ReactNativeViewController.swift
import UIKit
class ReactNativeViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let reactViewWrapper: ReactNativeView = ReactNativeView(frame:    self.view.frame)
    self.view.addSubview(reactViewWrapper)
  }
}
