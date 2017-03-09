//
//  Utility.swift
//
//
//  Created by darshan on 11/12/15.
//  Copyright © 2015 diet. All rights reserved.
//

import UIKit

class Utility: NSObject
{
    class func getPath(_ fileName: String) -> String
    {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    class func copyFile(_ fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            print(dbPath)
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            if (error != nil) {
                print("Error Occured")
                //alert.message = error?.localizedDescription
            } else {
                print("Successfully Copy")
            }
        }
    }
}
