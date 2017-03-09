
import Foundation
import CoreLocation
import CoreBluetooth

open class BeaconSender: NSObject, CBPeripheralManagerDelegate {
    
    open static let sharedInstance = BeaconSender()
    
    fileprivate var _region: CLBeaconRegion?
    fileprivate var _peripheralManager: CBPeripheralManager?
    
    fileprivate var _uuid = ""
    fileprivate var _identifier = ""
    
    
    open func startSending(UUID uuid: String, majorID: CLBeaconMajorValue, minorID: CLBeaconMinorValue, identifier: String) {
        
        _uuid = uuid
        _identifier = identifier
        
        stopSending() //stop sending when it's active
        
        // create the region that will be used to send
        _region = CLBeaconRegion(
            proximityUUID: UUID(uuidString: uuid)! as UUID,
            major: majorID,
            minor: minorID,
            identifier: identifier)
        
        _peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    open func stopSending() {
        
        _peripheralManager?.stopAdvertising()
    }
    
    
    // MARK: CBPeripheralManagerDelegate
    
    open func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        if peripheral.state == .poweredOn {
            
            let dataToBeAdvertised : [String : Any] = [
                CBAdvertisementDataLocalNameKey : _identifier as ImplicitlyUnwrappedOptional<AnyObject>,
                CBAdvertisementDataManufacturerDataKey : _region!.peripheralData(withMeasuredPower: nil),
                CBAdvertisementDataServiceUUIDsKey : [_uuid],
            ] as [String : Any]
            
            //let data = _region!.peripheralDataWithMeasuredPower(nil)
            peripheral.startAdvertising(dataToBeAdvertised)
            
            print("Start advertising as Beacon")
        }
        else if peripheral.state == .poweredOff {
            
            peripheral.stopAdvertising()
            
            print("Stop advertising as Beacon")
        }
        
    }
}
