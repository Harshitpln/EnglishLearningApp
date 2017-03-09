//
//  Dbhelper.swift
//  EnglishLearingApp
//
//  Created by Lokesh on 07/03/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit
class Dbhelper: NSObject
{
    func selectAllGroups() -> NSMutableArray
    {
        let mcqquestionsarray : NSMutableArray = NSMutableArray()
        let dbConn = FMDatabase(path: Utility.getPath("englishappDb.db") as String)
        var counter : Int32 = Int32()
        if (dbConn?.open())!
        {
            let selectQuery = "select * from MCQQuestions GROUP BY RowID ORDER BY RANDOM() LIMIT 10"
            let results:FMResultSet! = dbConn!.executeQuery(selectQuery,withArgumentsIn: nil)
            counter = 1;
            while results!.next() == true
            {
                let mcqgeter:MCQBean = MCQBean()
                mcqgeter.Rowid=results.int(forColumn: "RowID")
                mcqgeter.Question=results.string(forColumn: "QuestionText")
                mcqgeter.Answer=results.string(forColumn: "Answer")
                mcqgeter.option1=results.string(forColumn: "Option1")
                mcqgeter.option2=results.string(forColumn: "Option2")
                mcqgeter.option3=results.string(forColumn: "Option3")
                mcqgeter.usedflag=results.string(forColumn: "UsedFlag")
                mcqquestionsarray.add(mcqgeter)
                counter += 1
            }
            dbConn?.close()
        }
        else
        {
            print("Error: \(dbConn?.lastErrorMessage())")
        }
        return mcqquestionsarray
    }
}
