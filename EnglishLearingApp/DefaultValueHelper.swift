//
//  DefaultValueHelper.swift
//  EnglishLearingApp
//
//  Created by Lokesh on 09/03/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit

class DefaultValueHelper: NSObject {
    class func setPrefWithValueAndKey(_ Value:String,key:String)
    {
        let Defaults = UserDefaults.standard
        Defaults.set(Value, forKey: key)
        Defaults.synchronize()
    }
    class func GetPrefwithKey(_ Key:String) -> NSString
    {
        let Defaults = UserDefaults.standard
        return Defaults.value(forKey: Key) as! NSString
    }
    class func GetPrefAnyobjectKey(_ key:String) -> AnyObject {
        let Defaults = UserDefaults.standard
        return Defaults.value(forKey: key)! as AnyObject
    }
}
