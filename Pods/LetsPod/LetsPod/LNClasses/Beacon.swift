
import Foundation
import CoreLocation

open class Beacon : NSObject{
    
    open var uuid: UUID
    open var minor: NSNumber
    open var major: NSNumber
    open var identifier : String
    open var accuracy : Double = 0
    open var isEnter = false
    
    public init(uuid: UUID, minor: NSNumber, major: NSNumber) {
        self.uuid = uuid
        self.minor = minor
        self.major = major
        self.identifier = uuid.uuidString
    }
    public init(beacon : CLBeacon) {
        self.uuid = beacon.proximityUUID as UUID
        self.minor = beacon.minor
        self.major = beacon.major
        self.accuracy = beacon.accuracy
        self.identifier = beacon.proximityUUID.uuidString
    }
    open override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Beacon {
            return
                uuid == object.uuid &&
                    minor == object.minor &&
                    major == object.major
        } else {
            return false
        }
    }
}
public func == (lhs: Beacon, rhs: Beacon) -> Bool
{
    return
        lhs.uuid == rhs.uuid &&
            lhs.minor == rhs.minor &&
            lhs.major == rhs.major
}
