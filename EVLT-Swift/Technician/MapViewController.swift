//
//  MapViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let yvetotCoordinate = CLLocationCoordinate2D(latitude: 49.697448, longitude: 0.69079999)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerMapInCoordinate(coordinate: yvetotCoordinate)
        getProjects()
        self.drawPoints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func awakeFromNib() {
        self.navigationController?.tabBarItem.image = UIImage(named: "man")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getProjects() {
        APIRequests.importAllProjects { (projects) in
            // dictionary projects, addresses
            print(projects)
        }
    }
    
    func centerMapInCoordinate(coordinate: CLLocationCoordinate2D)  {
        var region = MKCoordinateRegion()
        region.center = coordinate
        region.span.latitudeDelta = 0.5;
        region.span.longitudeDelta = 0.5;
        mapView.region = region;
    }
    
    func drawPoints() {
        //draw here pins
        let annotation = EVLTAnnotation(coordinate: yvetotCoordinate)
        annotation.title = "Client name"
        annotation.subtitle = "Test"
        annotation.status = .urgency
        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            if let a = annotationView.annotation as? EVLTAnnotation {
                switch a.status {
                case .finished:
                    annotationView.image = #imageLiteral(resourceName: "pin_done")
                case .inProggress:
                    annotationView.image = #imageLiteral(resourceName: "pin3")
                case .planned:
                    annotationView.image = #imageLiteral(resourceName: "pin_planned")
                case .urgency:
                    annotationView.image = #imageLiteral(resourceName: "pin-urgency")
                }
            }
        }
        
        return annotationView
    }
    
}

//TODO: move this to an independent file
class EVLTAnnotation: NSObject, MKAnnotation {
    
    enum pinStatus {
        case urgency
        case planned
        case inProggress
        case finished
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String? = ""
    var image: UIImage? = nil
    var subtitle: String? = ""
    var phone: String? = ""
    var status: pinStatus = .planned
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
