import UIKit
import MapKit
import QuartzCore

class LetsAnnotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class LetsAnnotationView : MKAnnotationView,CAAnimationDelegate{
    var mapView : MKMapView?
    var lastReportedLocation : CLLocationCoordinate2D?
    var previousPoint : CLLocationCoordinate2D?
    
    
    func moveAnnotation(_ location: CLLocationCoordinate2D) {
        lastReportedLocation = location
        setPosition(lastReportedLocation!)
    }
    
    func setPosition(_ posValue: CLLocationCoordinate2D) {
        //extract the mapPoint from this dummy (wrapper) CGPoint struct
        let mapPoint: MKMapPoint = MKMapPointForCoordinate(posValue)
        let toPos: CGPoint = self.mapView!.convert(posValue, toPointTo: self.mapView)
        if let previousPoint = previousPoint {
            let pPoint = MKMapPointForCoordinate(previousPoint)
            self.transform = CGAffineTransform(rotationAngle: self.getHeadingForDirectionFromCoordinate(MKCoordinateForMapPoint(pPoint), toCoordinate: MKCoordinateForMapPoint(mapPoint)))
        }
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: self.center)
        animation.toValue = NSValue(cgPoint: toPos)
        animation.duration = 1.0
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        //[self.layer removeAllAnimations];
        self.layer.add(animation, forKey: "positionAnimation")
        
        if MKMapRectContainsPoint(self.mapView!.visibleMapRect, mapPoint) {
        }
        self.center = toPos
        (self.annotation as! LetsAnnotation).coordinate = posValue
        previousPoint = posValue
    }
    
    func getHeadingForDirectionFromCoordinate(_ fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> CGFloat {
        let fLat: Float = degreesToRadians(fromLoc.latitude)
        let fLng: Float = degreesToRadians(fromLoc.longitude)
        let tLat: Float = degreesToRadians(toLoc.latitude)
        let tLng: Float = degreesToRadians(toLoc.longitude)
        let degree: Float = atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))
        let deg: Float = radiandsToDegrees(Double(degree))
        return CGFloat(degreesToRadians(Double(deg)))
    }
}
/*
func mapView(mapView: MKMapView, viewForAnnotation annotation: LetsAnnotation) -> MKAnnotationView {
    let kMovingAnnotationViewId = "annotation"
    let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(kMovingAnnotationViewId)
    if let annotationView = annotationView as? LetsAnnotationView {
        anView = annotationView
    }
    else {
        anView = LetsAnnotationView(annotation: annotation, reuseIdentifier: kMovingAnnotationViewId)
        
    }
    //configure the annotation view
    anView!.image = UIImage(named: "Painted_sportscar___top_view_by_balagehun1991.png")
    anView!.bounds = CGRect(x: 0,y: 0,width: 10,height: 22.5)
    //initial bounds (default)
    anView!.mapView = mapView
    return anView!
}
 */
 
