//
//  ApplePayClass.swift
//  Pods
//
//  Created by Lokesh on 06/06/16.
//
//

import Foundation
import PassKit

@objc public protocol ApplePayDelegate {
    
    @objc optional
    func paymentAuthorizationFinish(_ payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!)
}

@available(iOS 9.0, *)
open class ApplePayClass : NSObject {
    
    open static let sharedInstance = ApplePayClass()
    open var delegate : ApplePayDelegate?
    open func startPayment(_ currentController : UIViewController,paymentSummaryItems : [PKPaymentSummaryItem]) -> PKPaymentRequest? {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]) {
            let request = PKPaymentRequest()
            request.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.merchantIdentifier = "Replace me with your Apple Merchant ID"
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.paymentSummaryItems = paymentSummaryItems
//            request.requiredShippingAddressFields = PKAddressField.PostalAddress
            let vc = PKPaymentAuthorizationViewController(paymentRequest: request)
            vc.delegate = self
            currentController.present(vc, animated: true, completion: nil)
            return request
        }
        return nil
    }
    
}


// MARK: PKPaymentAuthorizationViewControllerDelegate
@available(iOS 9.0, *)
extension ApplePayClass : PKPaymentAuthorizationViewControllerDelegate{
    
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        delegate?.paymentAuthorizationFinish?(payment, completion: completion)
    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, completion: @escaping ([PKPaymentSummaryItem]) -> Void) {
        print("paymentAuthorizationViewController")
    }
}
