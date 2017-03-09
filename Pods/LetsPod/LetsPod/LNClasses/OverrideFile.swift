//
//  OverrideFile.swift
//  Pods
//
//  Created by Lokesh on 05/05/16.
//
//

import Foundation

// MARK: infix operator
infix operator <->
infix operator ++=
infix operator ++
infix operator --
infix operator --=

//MARK: - Date -
public func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
public func > (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
public func < (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func == (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}
public func + (date: Date, tuple: (value: Int, unit: Calendar.Component)) -> Date {
    return Calendar.current.date(byAdding: tuple.unit, value: tuple.value, to: date, wrappingComponents: true)!
}
public func - (date: Date, tuple: (value: Int, unit: Calendar.Component)) -> Date {
    return Calendar.current.date(byAdding: tuple.unit, value: -tuple.value, to: date, wrappingComponents: true)!
}
public func += ( date: inout Date, tuple: (value: Int, unit: Calendar.Component)) {
    date =  Calendar.current.date(byAdding: tuple.unit, value: tuple.value, to: date, wrappingComponents: true)!
}
public func -= ( date: inout Date, tuple: (value: Int, unit: Calendar.Component)) {
    date =  Calendar.current.date(byAdding: tuple.unit, value: -tuple.value, to: date, wrappingComponents: true)!
}


//MARK: - String -
public func <-> (lhs: String, rhs: String) -> Bool {
    return (lhs.lowercased() == rhs.lowercased())
}
public func + (lhs: NSArray, rhs: NSObject) -> NSArray {
    return lhs.adding(rhs) as NSArray
}
public func + <T : Equatable>( lhs: inout [T], rhs: T) {
    lhs.append(rhs)
}
public func - <T : Equatable>( lhs: inout [T], rhs: T) {
    if let index = lhs.index(of: rhs) {
        lhs.remove(at: index)
    }
}
public func += ( array: inout NSArray, object: NSObject) {
    array = array + object
}
public func - (array: NSArray, object: NSObject) -> NSArray {
    let mutableArray = NSMutableArray(array: array)
    mutableArray.remove(object)
    return NSArray(array: mutableArray)
}
public func -= ( array: inout NSArray, object: NSObject) {
    array = array - object
}
public func ++ (left: NSArray, right: NSArray) -> NSArray {
    return left.addingObjects(from: right as [AnyObject]) as NSArray
}
public func ++= ( left: inout NSArray, right: NSArray) {
    left = left ++ right
}
public func + (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.adding(right)
}

public func + (left: NSDecimalNumber, right: NSNumber) -> NSDecimalNumber {
    let decimalRight:NSDecimalNumber = NSDecimalNumber(value: right.doubleValue)
    return left.adding(decimalRight);
}
public func + (left: NSNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    let decimalLeft:NSDecimalNumber = NSDecimalNumber(value: left.doubleValue);
    return decimalLeft.adding(right);
}
public func - (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.subtracting(right)
}
public func - (left: NSDecimalNumber, right: NSNumber) -> NSDecimalNumber {
    let decimalRight:NSDecimalNumber = NSDecimalNumber(value: right.doubleValue);
    return left.subtracting(decimalRight);
}
public func - (left: NSNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    let decimalLeft:NSDecimalNumber = NSDecimalNumber(value: left.doubleValue);
    return decimalLeft.subtracting(right);
}
public func * (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return right.multiplying(by: right)
}
public func * (left: NSDecimalNumber, right: NSNumber) -> NSDecimalNumber {
    let decimalRight:NSDecimalNumber = NSDecimalNumber(value: right.doubleValue);
    return left.multiplying(by: decimalRight);
}
public func * (left: NSNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    let decimalLeft:NSDecimalNumber = NSDecimalNumber(value: left.doubleValue);
    return decimalLeft.multiplying(by: right);
}
public func / (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.dividing(by: right)
}
public func / (left: NSDecimalNumber, right: NSNumber) -> NSDecimalNumber {
    let decimalRight:NSDecimalNumber = NSDecimalNumber(value: right.doubleValue);
    return left.dividing(by: decimalRight);
}
public func / (left: NSNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    let decimalLeft:NSDecimalNumber = NSDecimalNumber(value: left.doubleValue);
    return decimalLeft.dividing(by: right);
}
public func += ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left + right
}
public func -= ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left - right
}
public func *= ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left * right
}
public func /= ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left / right
}
prefix public func ++ ( operand: inout NSDecimalNumber) -> NSDecimalNumber {
    operand += NSDecimalNumber.one
    return operand
}
postfix public func ++ ( operand: inout NSDecimalNumber) -> NSDecimalNumber {
    let previousOperand = operand;
    ++operand
    return previousOperand
}
prefix public func -- ( operand: inout NSDecimalNumber) -> NSDecimalNumber {
    operand -= NSDecimalNumber.one
    return operand
}
postfix public func -- ( operand: inout NSDecimalNumber) -> NSDecimalNumber {
    let previousOperand = operand;
    --operand
    return previousOperand
}
public func + (left: NSNumber, right: NSNumber) -> NSNumber {
    return left + right
}
public func - (left: NSNumber, right: NSNumber) -> NSNumber {
    return left - right
}
public func * (left: NSNumber, right: NSNumber) -> NSNumber {
    return left * right
}
public func / (left: NSNumber, right: NSNumber) -> NSNumber {
    return left / right
}
public func += ( left: inout NSNumber, right: NSNumber) {
    left = left + right
}
public func -= ( left: inout NSNumber, right: NSNumber) {
    left = left - right
}
public func *= ( left: inout NSNumber, right: NSNumber) {
    left = left * right
}
public func /= ( left: inout NSNumber, right: NSNumber) {
    left = left / right
}
prefix public func ++ ( operand: inout NSNumber) -> NSNumber {
    operand = operand + 1.0
    return operand
}
postfix public func ++ ( operand: inout NSNumber) -> NSNumber {
    let previousOperand = operand;
    ++operand
    return previousOperand
}
prefix public func -- ( operand: inout NSNumber) -> NSNumber {
    operand = operand - 1.0
    return operand
}
postfix public func -- ( operand: inout NSNumber) -> NSNumber {
    let previousOperand = operand;
    --operand
    return previousOperand
}
public func + (set: NSSet, object: NSObject) -> NSSet {
    return set.adding(object) as NSSet
}
public func += ( set: inout NSSet, object: NSObject) {
    set = set + object
}
public func - (set: NSSet, object: NSObject) -> NSSet {
    let mutableSet = NSMutableSet(set: set)
    mutableSet.remove(object)
    return mutableSet
}
public func -= ( set: inout NSSet, object: NSObject) {
    set = set - object
}
public func ++ (left: NSSet, right: NSSet) -> NSSet {
    return left.adding(right) as NSSet
}

public func ++ (left: NSSet, right: NSArray) -> NSSet {
    return left.adding(right) as NSSet
}
public func ++= ( left: inout NSSet, right: NSSet) {
    left = left ++ right
}
public func ++= ( left: inout NSSet, right: NSArray) {
    left = left ++ right
}
public func -- (left: NSSet, right: NSSet) -> NSSet {
    let resultSet = NSMutableSet(set: left)
    resultSet.minus(right as Set<NSObject>)
    return NSSet(set: resultSet)
}
public func -- (left: NSSet, right: NSArray) -> NSSet {
    let resultSet = NSMutableSet(set: left)
    resultSet.minus(Set(arrayLiteral: right))
    return NSSet(set: resultSet)
}
public func --= ( left: inout NSSet, right: NSSet) {
    left = left -- right
}
public func --= ( left: inout NSSet, right: NSArray) {
    left = left -- right
}
public func + (dictionary: NSDictionary, tuple: (NSObject: NSCopying, NSObject)) -> NSDictionary {
    let resultDictionary = NSMutableDictionary(dictionary: dictionary)
    resultDictionary.setObject(tuple.1, forKey: tuple.0)
    return resultDictionary
}
public func += ( dictionary: inout NSDictionary, tuple: (NSObject: NSCopying, NSObject)) {
    dictionary = dictionary + tuple
}
public func ++ (left: NSDictionary, right: NSDictionary) -> NSDictionary {
    let resultDictionary = NSMutableDictionary(dictionary: left)
    resultDictionary.addEntries(from: right as! [AnyHashable: Any])
    return resultDictionary
}
public func ++= ( left: inout NSDictionary, right: NSDictionary) {
    left = left ++ right
}
public func - ( lhs: inout String, rhs: String) {
    lhs = lhs.replacingOccurrences(of: rhs, with: "")
}
public func uniq<S: Sequence, E: Hashable>(_ source: S) -> [E] where E==S.Iterator.Element {
    var seen: [E:Bool] = [:]
    return source.filter { seen.updateValue(true, forKey: $0) == nil }
}
