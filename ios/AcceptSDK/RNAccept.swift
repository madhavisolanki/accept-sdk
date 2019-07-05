//
//  RNAccept.swift
//  AcceptSDK
//
//  Created by Madhavi  Solanki on 26/06/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import UIKit
import PassKit
import AuthorizeNetAccept


@objc(RNAccept)
class RNAccept: UIViewController,PKPaymentAuthorizationViewControllerDelegate {
  @objc
  static var clientKey:String = ""
  @objc
  static var clientName:String = ""
  @objc
  static var env:AcceptSDKEnvironment = AcceptSDKEnvironment.ENV_TEST
  
  @objc let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]

  @objc func methodQueue() ->  DispatchQueue {
    return DispatchQueue.main
  }
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc func configure(_ clientName: NSString,
                           clientKey: NSString) -> Void {
    RNAccept.clientName = clientName as String
    RNAccept.clientKey = clientKey as String
    RNAccept.env = AcceptSDKEnvironment.ENV_TEST
  }
  
  @objc func doCardPayment(_ cardNumber: NSString,
                           expirationMonth: NSString,
                           expirationYear: NSString,
                           cvvCode: NSString,
                          resolver resolve: @escaping RCTPromiseResolveBlock,
                          rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    
    let handler = AcceptSDKHandler(environment: RNAccept.env)
    
    let request = AcceptSDKRequest()
    request.merchantAuthentication.name = RNAccept.clientName
    request.merchantAuthentication.clientKey = RNAccept.clientKey
    
    request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = cardNumber as String
    request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = expirationMonth as String
    request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = expirationYear as String
    request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = cvvCode as String
    
    handler!.getTokenWithRequest(request, successHandler: { (inResponse:AcceptSDKTokenResponse) -> () in
      DispatchQueue.main.async(execute: {
        print("Token--->%@", inResponse.getOpaqueData().getDataValue())
        var output = String(format: "Response: %@\nData Value: %@ \nDescription: %@", inResponse.getMessages().getResultCode(), inResponse.getOpaqueData().getDataValue(), inResponse.getOpaqueData().getDataDescriptor())
        output = output + String(format: "\nMessage Code: %@\nMessage Text: %@", inResponse.getMessages().getMessages()[0].getCode(), inResponse.getMessages().getMessages()[0].getText())
        resolve(output)
      })
    }) { (inError:AcceptSDKErrorResponse) -> () in
      DispatchQueue.main.async(execute: {
        let error = NSError(domain: "",
                            code: 0,
                            userInfo: nil)

        reject(inError.getMessages().getResultCode(),inError.getMessages().getMessages()[0].getText(), error)
      })
    }
  }
  
  @objc func doApplePay(resolver resolve: @escaping RCTPromiseResolveBlock,
                        rejecter reject: @escaping RCTPromiseRejectBlock) {
    let supportedNetworks = [ PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa ]
    
    if PKPaymentAuthorizationViewController.canMakePayments() == false {
      let err = NSError(domain: "", code: 0, userInfo: nil)
      reject("0", "Apple pay is not available", err)
    }
    
    if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) == false {
      let err = NSError(domain: "", code: 0, userInfo: nil)
      reject("0", "No Apple Pay payment methods available", err)
    }
    
    let request = PKPaymentRequest()
    request.currencyCode = "USD"
    request.countryCode = "US"
    request.merchantIdentifier = "merchant.authorize.net.test.dev15"
    request.supportedNetworks = SupportedPaymentNetworks
    // DO NOT INCLUDE PKMerchantCapability.capabilityEMV
    request.merchantCapabilities = PKMerchantCapability.capability3DS
    
    request.paymentSummaryItems = [
      PKPaymentSummaryItem(label: "Total", amount: 254.00)
    ]
    
    let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
    applePayController?.delegate = self

    self.present(applePayController!, animated: true, completion: nil)
  // implement you method
  }
  
   func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (@escaping (PKPaymentAuthorizationStatus) -> Void)) {
    print("paymentAuthorizationViewController delegates called")
    
    if payment.token.paymentData.count > 0 {
      let base64str = self.base64forData(payment.token.paymentData)
      let messsage = String(format: "Data Value: %@", base64str)
      let alert = UIAlertController(title: "Authorization Success", message: messsage, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      return self.performApplePayCompletion(controller, alert: alert)
    } else {
      let alert = UIAlertController(title: "Authorization Failed!", message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      return self.performApplePayCompletion(controller, alert: alert)
    }
  }
  
  @objc func performApplePayCompletion(_ controller: PKPaymentAuthorizationViewController, alert: UIAlertController) {
    controller.dismiss(animated: true, completion: {() -> Void in
      self.present(alert, animated: false, completion: nil)
    })
  }
  
  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true, completion: nil)
    print("paymentAuthorizationViewControllerDidFinish called")
  }
  
  @objc func base64forData(_ theData: Data) -> String {
    let charSet = CharacterSet.urlQueryAllowed
    
    let paymentString = NSString(data: theData, encoding: String.Encoding.utf8.rawValue)!.addingPercentEncoding(withAllowedCharacters: charSet)
    
    return paymentString!
  }
  
}
