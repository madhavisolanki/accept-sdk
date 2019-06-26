//
//  ReactNativeView.swift
//  AcceptSDK
//
//  Created by Madhavi  Solanki on 26/06/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

// ReactNativeView.swift
import UIKit

class ReactNativeView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initializeReactView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initializeReactView()
  }
  func initializeReactView() {
    let jsCodeLocation = URL(string:"http://localhost:8081/index.ios.bundle?platform=ios"
    )
    //  let jsCodeLocation = Bundle.main.url(forResource: "main",   withExtension: "jsbundle")
    let rootView = RCTRootView(bundleURL: jsCodeLocation as URL!,
                               moduleName: "AcceptSDK",
                               initialProperties: nil,
                               launchOptions: nil)
    rootView?.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(rootView!)
    let views: [String: UIView] = ["rootView": rootView!]
    var constraints =      NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[rootView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat:   "H:|-0-[rootView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    self.addConstraints(constraints)
    self.layoutIfNeeded()
  }
}
