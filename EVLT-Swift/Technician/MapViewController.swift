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
    var selectedProjectAddress: (project: Project, address: Place)!
    var projectAddressArray: [(project: Project, address: Place)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerMapInCoordinate(coordinate: yvetotCoordinate)
        getProjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func awakeFromNib() {
        self.navigationController?.tabBarItem.image = UIImage(named: "man")
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProjectDetailsSegue" {
            let vc = segue.destination as! ProjectUpdatesViewController
            vc.projectAddress = self.selectedProjectAddress
        }else if segue.identifier == "ProjectListSegue" {
            let vc = segue.destination as! ProjectViewController
            vc.projectAddressArray = self.projectAddressArray

        }
    }
 

    func getProjects() {
        APIRequests.importAllProjects { (projects) in
            print(projects)
            self.projectAddressArray = []
            for projectObject in projects["chantiers"] as! Array<Dictionary<String, Any>> {
                let project = Project(dictionaryObject: projectObject)
                //got project, getting addresses
                for addressObject in projects["adresses"] as! Array<Dictionary<String, Any>> {
                    if "\(project.chantier_id)" == addressObject["chantier_id"] as! String {
                        //create address instance and combine it with project and add pin to map
                        let address = Place(dictionary: addressObject)
                        DispatchQueue.main.async {
                            self.drawPoint(project: project, address: address)
                        }
                        self.projectAddressArray.append((project: project, address: address))
                    }else{
                        continue
                    }
                
                }

            }
            
            // dictionary projects, addresses
            
            //getting
        }
    }
    
    func centerMapInCoordinate(coordinate: CLLocationCoordinate2D)  {
        var region = MKCoordinateRegion()
        region.center = coordinate
        region.span.latitudeDelta = 2.0;
        region.span.longitudeDelta = 2.0;
        mapView.region = region;
    }
    
    func drawPoint(project: Project, address: Place) {
        //draw here pins
        let annotation = EVLTAnnotation(projectAddress: (project: project, address: address))
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(view.annotation as! EVLTAnnotation)
        //ProjectDetailsSegue
        self.selectedProjectAddress = (view.annotation as! EVLTAnnotation).projectAddress
        self.performSegue(withIdentifier: "ProjectDetailsSegue", sender: self)
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
    
    var projectAddress: (project: Project, address: Place)?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    init(projectAddress: (project: Project, address: Place)) {
        self.projectAddress = projectAddress
        switch projectAddress.project.status {
        case .accepted:
            self.status = .finished
        case .active:
            self.status = .urgency
        case .inactive:
            self.status = .planned
        case .visitFait:
            self.status = .inProggress
        }
        self.title = projectAddress.project.type
        self.subtitle = "\(projectAddress.address.numberString!), \(projectAddress.address.street), \(projectAddress.address.postalCode) \(projectAddress.address.city)"
        self.coordinate = CLLocationCoordinate2D(latitude: projectAddress.address.coordinate.latitude, longitude:  projectAddress.address.coordinate.longitude)
    }
}
