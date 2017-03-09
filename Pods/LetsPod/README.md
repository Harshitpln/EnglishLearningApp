![LetsNurture](http://engineering.letsnurture.com/wp-content/themes/alizee/images/logo_Logo.png)

# LetsNurture's Pod

[![Version](https://img.shields.io/cocoapods/v/LetsPod.svg?style=flat)](http://cocoapods.org/pods/LetsPod)
[![License](https://img.shields.io/cocoapods/l/LetsPod.svg?style=flat)](http://cocoapods.org/pods/LetsPod)
[![Platform](https://img.shields.io/cocoapods/p/LetsPod.svg?style=flat)](http://cocoapods.org/pods/LetsPod)
[![Twitter](https://img.shields.io/badge/twitter-@LetsNurture-blue.svg?style=flat)](http://twitter.com/LetsNurture)
[![Facebook](https://img.shields.io/badge/facebook-LetsNurture-blue.svg?style=flat)](https://www.facebook.com/LetsNurture)


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8

## Installation

LetsPod is available through [CocoaPods](http://cocoapods.org). To install

```bash
$ sudo gem install cocoapods
```

it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "LetsPod"
```

### Features

- [LetsButton (IBDesignable)] (#letsbutton-ibdesignable)
- [LetsImageView (IBDesignable)](#letsimageview-ibdesignable)
- [LetsLabel (IBDesignable)](#letslabel-ibdesignable)
- [LetsTextField (IBDesignable)](#letstextfield-ibdesignable)
- [LetsTextView (IBDesignable)](#letstextview-ibdesignable)
- [LetsView (IBDesignable)](#letsview-ibdesignable)
- [NSDate (Extension)](#nsdate-extension)
- [UISearchBar (Extension)](#uisearchBar-extension)
- [UIImage (Extension)](#uiimage-extension)
- [UIToolbar (Extension)](#uitoolbar-extension)
- [UINavigationBar (Extension)](#uinavigationbar-extension)
- [String (Extension)](#string-extension)
- [UIViewController (Extension)](#uiviewcontroller-extension)


## Values

- [ ] Not Inspectable
- [x] Inspectable


## LetsButton (IBDesignable)

- [ ] topBorderView: UIView
- [ ] bottomBorderView: UIView
- [ ] leftBorderView: UIView
- [ ] rightBorderView: UIView
- [x] isRightImage : Bool
- [x] highlightedImage : UIImage
- [x] normalImage: UIImage
- [x] normalTextColor : UIColor
- [x] highlightedTextColor : UIColor
- [x] highlightedBackgroundColor: UIColor
- [x] normalBackgroundColor: UIColor
- [x] borderColor: UIColor
- [x] borderWidth: CGFloat
- [x] cornerRadius : CGFloat
- [x] isCircle: Bool
- [x] topBorderColor : UIColor
- [x] topBorderHeight : CGFloat
- [x] bottomBorderColor : UIColor
- [x] bottomBorderHeight : CGFloat
- [x] leftBorderColor : UIColor
- [x] leftBorderHeight : CGFloat
- [x] rightBorderColor : UIColor
- [x] rightBorderHeight : CGFloat



## LetsImageView (IBDesignable)
- [ ] topBorder: UIView
- [ ] bottomBorder: UIView
- [ ] leftBorder: UIView
- [ ] rightBorder: UIView
- [x] borderColor: UIColor
- [x] borderWidth: CGFloat
- [x] cornerRadius: CGFloat
- [x] topBorderColor : UIColor
- [x] topBorderHeight : CGFloat
- [x] bottomBorderColor : UIColor
- [x] bottomBorderHeight : CGFloat
- [x] leftBorderColor : UIColor
- [x] leftBorderHeight : CGFloat
- [x] rightBorderColor : UIColor
- [x] rightBorderHeight : CGFloat


## LetsLabel (IBDesignable)
- [ ] topBorder: UIView
- [ ] bottomBorder: UIView
- [ ] leftBorder: UIView
- [ ] rightBorder: UIView
- [x] borderColor: UIColor
- [x] borderWidth: CGFloat
- [x] isCircle: Bool
- [x] cornerRadius: CGFloat
- [x] fitToWidth: Bool
- [x] paddingLeft: CGFloat
- [x] topBorderColor : UIColor
- [x] topBorderHeight : CGFloat
- [x] bottomBorderColor : UIColor
- [x] bottomBorderHeight : CGFloat
- [x] leftBorderColor : UIColor
- [x] leftBorderHeight : CGFloat
- [x] rightBorderColor : UIColor
- [x] rightBorderHeight : CGFloat


## LetsTextField (IBDesignable)
- [ ] topBorder: UIView
- [ ] bottomBorder: UIView
- [ ] leftBorder: UIView
- [ ] rightBorder: UIView
- [ ] leftimageview : UIImageView
- [ ] rightimageview : UIImageView
- [x] rightImage : UIImage
- [x] rightviewWidth : CGFloat
- [x] borderColor: UIColor
- [x] borderWidth: CGFloat
- [x] cornerRadius: CGFloat
- [x] placeHolderColor : UIColor
- [x] leftImage : UIImage
- [x] leftviewWidth : CGFloat
- [x] paddingLeft: CGFloat
- [x] paddingRight: CGFloat
- [x] topBorderColor : UIColor
- [x] topBorderHeight : CGFloat
- [x] bottomBorderColor : UIColor
- [x] bottomBorderHeight : CGFloat
- [x] leftBorderColor : UIColor
- [x] leftBorderHeight : CGFloat
- [x] rightBorderColor : UIColor
- [x] rightBorderHeight : CGFloat


## LetsTextView (IBDesignable)
- [x] placeholderLabel: UILabel
- [x] placeholderColor : UIColor
- [x] placeholder : String


## LetsView (IBDesignable)
- [x] topBorder: UIView
- [x] bottomBorder: UIView
- [x] leftBorder: UIView
- [x] rightBorder: UIView
- [x] borderColor: UIColor
- [x] borderWidth: CGFloat
- [x] cornerRadius: CGFloat
- [x] topBorderColor : UIColor
- [x] topBorderHeight : CGFloat
- [x] bottomBorderColor : UIColor
- [x] bottomBorderHeight : CGFloat
- [x] leftBorderColor : UIColor
- [x] leftBorderHeight : CGFloat
- [x] rightBorderColor : UIColor
- [x] rightBorderHeight : CGFloat


## NSDate (Extension)
- [ ] day: UInt
- [ ] month: UInt
- [ ] year: UInt
- [ ] hour: UInt
- [ ] minute: UInt
- [ ] second: UInt
- [ ] func isGreaterThan(date: NSDate) -> Bool
- [ ] func isLessThan(date: NSDate) -> Bool
- [ ] func plusSeconds(s: UInt) -> NSDate
- [ ] func minusSeconds(s: UInt) -> NSDate
- [ ] func plusMinutes(m: UInt) -> NSDate
- [ ] func minusMinutes(m: UInt) -> NSDate
- [ ] func plusHours(h: UInt) -> NSDate
- [ ] func minusHours(h: UInt) -> NSDate
- [ ] func plusDays(d: UInt) -> NSDate
- [ ] func minusDays(d: UInt) -> NSDate
- [ ] func plusWeeks(w: UInt) -> NSDate
- [ ] func minusWeeks(w: UInt) -> NSDate
- [ ] func plusMonths(m: UInt) -> NSDate
- [ ] func minusMonths(m: UInt) -> NSDate
- [ ] func plusYears(y: UInt) -> NSDate
- [ ] func minusYears(y: UInt) -> NSDate
- [ ] func midnightUTCDate() -> NSDate
- [ ] class func secondsBetween(date1 d1:NSDate, date2 d2:NSDate) -> Int
- [ ] class func minutesBetween(date1 d1: NSDate, date2 d2: NSDate) -> Int
- [ ] class func hoursBetween(date1 d1: NSDate, date2 d2: NSDate) -> Int
- [ ] class func daysBetween(date1 d1: NSDate, date2 d2: NSDate) -> Int
- [ ] class func weeksBetween(date1 d1: NSDate, date2 d2: NSDate) -> Int
- [ ] class func monthsBetween(date1 d1: NSDate, date2 d2: NSDate) -> Int
- [ ] class func yearsBetween(date1 d1: NSDate, date2 d2: NSDate) -> Int

## UISearchBar (Extension)
- [ ] func radiusRemove()


## UIImage (Extension)
- [ ] getPixelColor(pos: CGPoint) -> UIColor


## UIToolbar (Extension)
- [ ] showHairline()
- [ ] hideHairline()


## UINavigationBar (Extension)
- [ ] showBottomHairline()
- [ ] hideBottomHairline()


## String (Extension)
- [ ] length : Int
- [ ] ns: NSString
- [ ] pathExtension: String
- [ ] lastPathComponent: String
- [ ] contains(s: String) -> Bool
- [ ] replace(target: String, withString: String) -> String
- [ ] subscript (i: Int) -> Character
- [ ] subscript (r: Range<Int>) -> String
- [ ] subString(startIndex: Int, length: Int) -> String
- [ ] indexOf(target: String) -> Int
- [ ] indexOf(target: String, startIndex: Int) -> Int
- [ ] lastIndexOf(target: String) -> Int
- [ ] isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
- [ ] getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]

## UIViewController (Extension)
- [ ] Table separator remove automatically




### LetsPod for the LN Team.
