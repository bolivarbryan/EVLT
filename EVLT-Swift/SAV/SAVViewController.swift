//
//  SAVViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 10/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SAVViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let yvetotCoordinate = CLLocationCoordinate2D(latitude: 49.697448, longitude: 0.69079999)
    var selectedProjectAddress: (project: Project, address: Place)!
    var projectAddressArray: [(project: Project, address: Place)] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerMapInCoordinate(coordinate: yvetotCoordinate)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProjects()
    }

    override func awakeFromNib() {
        self.navigationController?.tabBarItem.image = UIImage(named: "plier")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            vc.parentVC = self
        }
    }

    func getProjects() {
        APIRequests.importAllProjects { (projects) in
            print(projects)
            self.projectAddressArray = []
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for projectObject in projects["chantiers"] as! Array<Dictionary<String, Any>> {
                let project = Project(dictionaryObject: projectObject)
                //got project, getting addresses
                for addressObject in projects["adresses"] as! Array<Dictionary<String, Any>> {
                    if "\(project.chantier_id)" == addressObject["chantier_id"] as! String {
                        //create address instance and combine it with project and add pin to map
                        let address = Place(dictionary: addressObject)
                        
                        if (project.statut_technicien != "") {
                            DispatchQueue.main.async {
                                self.drawPoint(project: project, address: address)
                            }
                            self.projectAddressArray.append((project: project, address: address))
                        }
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


extension SAVViewController: MKMapViewDelegate {
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
                case .urgency:
                    annotationView.image = #imageLiteral(resourceName: "pin-urgency")
                default:
                    annotationView.image = #imageLiteral(resourceName: "pin3")
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

