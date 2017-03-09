

import Foundation
import CoreLocation



public protocol BeaconMonitorDelegate {
    
    func receivedAllBeacons(_ monitor: BeaconMonitor, beacons: [Beacon], inRegion region: CLBeaconRegion)
    func receivedMatchingBeacons(_ monitor: BeaconMonitor, beacons: [Beacon], inRegion region: CLBeaconRegion)
    
    func didEnterBeacon(_ monitor: BeaconMonitor, beaconRegion: CLBeaconRegion)
    func didExitBeacon(_ monitor: BeaconMonitor, beaconRegion: CLBeaconRegion)
}


/*
 
 @CODE: Code for Beacon integration
 
 var monitor: BeaconMonitor!
 var beaconsValues = [Beacon]()
 
 override func viewDidLoad() {
    super.viewDidLoad()
     let uuids = [UUID(UUIDString: "fda50693-a4e2-4fb1-afcf-c6eb07647825")!,
     UUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!]
     monitor = BeaconMonitor(uuids: uuids)
     monitor.delegate = self
     monitor.startListening()
 }

extension ViewController: BeaconMonitorDelegate {
    func receivedAllBeacons(monitor: BeaconMonitor, beacons: [Beacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons{
            if let index = beaconsValues.indexOf(beacon) {
                let b = beaconsValues[index]
                if b.isEnter && beacon.accuracy > 3.1 {
                    beacon.isEnter = false
                    NSLog("Exit region \(beacon.identifier) : \(beacon.major) - \(beacon.minor)")
                }
                else if b.isEnter == false && beacon.accuracy < 2.10 {
                    beacon.isEnter = true
                    NSLog("Enter region \(beacon.identifier) : \(beacon.major) - \(beacon.minor)")
                }
                else {
                    beacon.isEnter = b.isEnter
                }
            }
            else {
                if beacon.isEnter == false && beacon.accuracy < 2.10 {
                    beacon.isEnter = true
                }
            }
        }
        for (_,beacon) in beaconsValues.enumerate() {
            if beacons.contains(beacon) {
                if let index = beaconsValues.indexOf(beacon) {
                    beaconsValues.removeAtIndex(index)
                }
            }
            else if  beacon.isEnter == true {
                beacon.isEnter = false
                NSLog("Exit region \(beacon.identifier) : \(beacon.major) - \(beacon.minor)")
            }
        }
        beaconsValues.appendContentsOf(beacons)
        tableview.reloadData()
    }
    func receivedMatchingBeacons(monitor: BeaconMonitor, beacons: [Beacon], inRegion region: CLBeaconRegion) {
        
    }
    func didEnterBeacon(monitor: BeaconMonitor, beaconRegion: CLBeaconRegion){
        NSLog("Did Enter region \(beaconRegion.identifier) : \(beaconRegion.major) - \(beaconRegion.minor)")
    }
    func didExitBeacon(monitor: BeaconMonitor, beaconRegion: CLBeaconRegion){
        NSLog("Did Exit region \(beaconRegion.identifier) : \(beaconRegion.major) - \(beaconRegion.minor)")
    }
}
*/
open class BeaconMonitor: NSObject  {
    
    open var delegate: BeaconMonitorDelegate?
    
    // Name that is used as the prefix for the region identifier.
    let regionIdentifier = "BeaconMonitor"
    
    // CLLocationManager that will listen and react to Beacons.
    var locationManager: CLLocationManager?
    var beaconsValues = [Beacon]()
    // Dictionary containing the CLBeaconRegions the locationManager is listening to. Each region is assigned to it's UUID String as the key.
    open var regions = [String: CLBeaconRegion]()
    
    var beaconsListening: [Beacon]?
    
    
    // MARK: - Init methods
    
    /**
    Init the BeaconMonitor and listen only to the given UUID.
    - parameter uuid: UUID for the region the locationManager is listening to.
    - returns: Instance
    */
    public init(uuid: UUID) {
        super.init()
        
        regions[uuid.uuidString] = self.regionForUUID(uuid)
    }
    
    /**
    Init the BeaconMonitor and listen to multiple UUIDs.
    - parameter uuids: Array of UUIDs for the regions the locationManager should listen to.
    - returns: Instance
    */
    public init(uuids: [UUID]) {
        super.init()
        
        for uuid in uuids {
            regions[uuid.uuidString] = self.regionForUUID(uuid)
        }
    }
    
    /**
    Init the BeaconMonitor and listen only to the given Beacons.
    The UUID(s) for the regions will be extracted from the Beacon Array. When Beacons with different UUIDs are defined multiple regions will be created.
    - parameter beacons: Beacon instances the BeaconMonitor is listening for
    - returns: Instance
    */
    public init(beacons: [Beacon]) {
        super.init()
        
        beaconsListening = beacons
        
        // create a CLBeaconRegion for each different UUID
        for uuid in distinctUnionOfUUIDs(beacons) {
            
            regions[uuid.uuidString] = self.regionForUUID(uuid)
        }
    }
    
    /**
     Init the BeaconMonitor and listen to the given Beacon.
     From the Beacon values (uuid, major and minor) a concrete CLBeaconRegion will be created.
     - parameter beacon: Beacon instance the BeaconMonitor is listening for and it will be used to create a concrete CLBeaconRegion.
     - returns: Instance
     */
    public init(beacon: Beacon) {
        super.init()
        
        beaconsListening = [beacon]
        
        regions[beacon.uuid.uuidString] = self.regionForBeacon(beacon)
    }
    
    
    // MARK: - Listen/Stop
    
    /**
    Start listening for Beacons.
    The settings are used from the init mthod.
    */
    open func startListening() {
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager!.requestAlwaysAuthorization()
        }
    }
    
    /**
    Stop listening for all regions.
    */
    open func stopListening() {
        for (uuid, region) in regions {
            stopListening(region: region)
            regions[uuid] = nil
        }
    }
    
    /**
    Stop listening only for the region with the given UUID.
    - parameter uuid: UUID of the region to stop listening for
    */
    open func stopListening(_ uuid: UUID) {
        if let region = regions[uuid.uuidString] {
            stopListening(region: region)
            regions[uuid.uuidString] = nil
        }
    }
    
    
    // MARK: - Helper
    func regionForUUID(_ uuid: UUID) -> CLBeaconRegion {
        let region = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: "\(regionIdentifier)-\(uuid.uuidString)")
        region.notifyEntryStateOnDisplay = true
        return region
    }
    
    func regionForBeacon(_ beacon: Beacon) -> CLBeaconRegion {
        let region = CLBeaconRegion(proximityUUID: beacon.uuid as UUID,
                                    major: CLBeaconMajorValue(beacon.major.intValue),
                                    minor: CLBeaconMinorValue(beacon.minor.intValue),
                                    identifier: "\(regionIdentifier)-\(beacon.uuid.uuidString)")
        region.notifyEntryStateOnDisplay = true
        return region
    }
    
    func stopListening(region: CLBeaconRegion) {
        locationManager?.stopRangingBeacons(in: region)
        locationManager?.stopMonitoring(for: region)
    }
    
    func distinctUnionOfUUIDs(_ beacons: [Beacon]) -> [UUID] {
        var dict = [UUID : Bool]()
        let filtered = beacons.filter { (element: Beacon) -> Bool in
            if dict[element.uuid] == nil {
                dict[element.uuid] = true
                return true
            }
            return false
        }
        
        return filtered.map { $0.uuid}
    }
    
}


// MARK: - CLLocationManagerDelegate

extension BeaconMonitor: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        beaconsValues = beaconsValues.filter{ $0.uuid  != region.proximityUUID }
        var objc = [Beacon]()
        for beaconValue in knownBeacons {
            objc.append(Beacon(beacon: beaconValue))
        }
        beaconsValues.append(contentsOf: objc)
        
        var matchingBeacons = [Beacon]()
        if beaconsListening != nil {
            for b in beaconsValues {
                if beaconsListening!.contains(where: { $0.major == b.major && $0.minor == b.minor && $0.uuid == b.uuid }) {
                    matchingBeacons.append(b)
                }
            }
        }
        
        if matchingBeacons.count > 0 {
            delegate?.receivedMatchingBeacons(self, beacons: matchingBeacons,inRegion: region)
        }
        if knownBeacons.count > 0 {
            delegate?.receivedAllBeacons(self, beacons: beaconsValues,inRegion: region)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("did start monitoring")
        manager.requestState(for: region)
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let beacon = region as! CLBeaconRegion
        if (state == .inside) {
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
        }
        else {
            manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
    }
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {

        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
           
            for (_, region) in regions {
                manager.startMonitoring(for: region)
            }
            
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let beacon = region as! CLBeaconRegion
        delegate?.didEnterBeacon(self, beaconRegion: beacon)
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let beacon = region as! CLBeaconRegion
        delegate?.didExitBeacon(self, beaconRegion: beacon)
    }
    
}
