//
//  MapViewController.h
//  EVLT
//
//  Created by bolivarbryan on 25/08/16.
//  Copyright © 2016 EVLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Projet.h"

@interface MapViewController : UIViewController
{
    NSMutableArray *listeAffiche;
NSMutableArray *transitClient;
NSArray *clients;
NSArray *projets;
}

@property (strong, nonatomic) Projet *projet;

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(weak, nonatomic) CLLocation *locTest;

@property(weak, nonatomic) NSString *addressText;

@end
