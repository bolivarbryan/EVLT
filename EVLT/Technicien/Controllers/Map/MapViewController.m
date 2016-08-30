//
//  MapViewController.m
//  EVLT
//
//  Created by bolivarbryan on 25/08/16.
//  Copyright © 2016 EVLT. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "Projet2.h"
#import "TECProjectAnnotation2.h"
#import "Client2.h"

//#import "detailProjetBisViewController2.h"



@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) NSArray *coords;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title  = @"Technicien";
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.coords = delegate.coords;
    clients = delegate.clients;
    projets = delegate.projets;
    
    
    // CARTE INITIALE
    CLLocationCoordinate2D noLocation;
    noLocation = CLLocationCoordinate2DMake(49.697448, 0.69079999);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 75000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    //  self.mapView.showsUserLocation = YES;
    // FIN CARTE
    
    /*
     MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
     myAnnotation.coordinate = CLLocationCoordinate2DMake(49.697448, 0.69079999);
     myAnnotation.title = @"Matthews Pizza";
     myAnnotation.subtitle = @"Best Pizza in Town";
     [self.mapView addAnnotation:myAnnotation];
     */
    
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    /*
     
     // If no pin view already exists, create a new one.
     MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
     initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
     customPinView.pinColor = MKPinAnnotationColorPurple;
     customPinView.animatesDrop = YES;
     customPinView.canShowCallout = YES;
     
     // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
     UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
     customPinView.rightCalloutAccessoryView = rightButton;
     
     // Add a custom image to the left side of the callout.
     UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyCustomImage.png"]];
     customPinView.leftCalloutAccessoryView = myCustomImage;
     
     return customPinView;
     
     */
    
    
    MKPinAnnotationView *customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!customPinView) {
        customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        customPinView.canShowCallout = YES;
        
        customPinView.pinColor = MKPinAnnotationColorGreen;
        //   customPinView.image = [UIImage imageNamed:@"valider.png"];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        customPinView.rightCalloutAccessoryView = rightButton;
    }
    
    return customPinView;
    
    
    
    // - (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
    
    //   MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    //   annView.pinColor = MKPinAnnotationColorGreen;
    //   return annView;
    
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    TECProjectAnnotation *anno = (TECProjectAnnotation *)view.annotation;
    self.projet = anno.project;
    
    [self performSegueWithIdentifier:@"carteVersProjet" sender:self];
    
    //   AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //   delegate.projectManager.selectedProject = p;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:TECProjectsDidUpdateNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification)
     {
         [self updateProjects];
     }];
    [self updateProjects];
}

- (void)updateProjects {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSMutableArray *annotations = [NSMutableArray array];
    for (Projet *p in projets) {
        
        TECProjectAnnotation *anno = [[TECProjectAnnotation alloc] init];
        
        NSMutableSet *selectedProj = [NSMutableSet set];
        Projet *proj = [self projetWithId:p.identifier];
        [selectedProj addObject:proj];
        listeAffiche = [[selectedProj allObjects] mutableCopy];
        Projet *p2 = [listeAffiche objectAtIndex:0];
        
        NSMutableSet *selectedClients = [NSMutableSet set];
        Client *client = [self clientWithId:p.clientID];
        [selectedClients addObject:client];
        transitClient = [[selectedClients allObjects] mutableCopy];
        Client *c = [transitClient objectAtIndex:0];
        
        anno.coordinate = CLLocationCoordinate2DMake(p2.latitude, p2.longitude);
        anno.title = [NSString stringWithFormat:@"%@ %@", c.firstName, c.lastName];
        anno.subtitle = [NSString stringWithFormat:@"%@ - %@", p.type, p.statut];
        anno.project = p;
        
        
        
        //    anno.image = [UIImage imageNamed:@"valider.png"];
        //    anno.centerOffset = CGPointMake(10, -20);
        [annotations addObject:anno];
        
        
    }
    
    [self.mapView addAnnotations:annotations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (Projet *)projetWithId:(NSString *)identifier {
    for (Projet *p in self.coords) {
        if ([p.identifier isEqualToString:identifier]) {
            return p;
        }
    }
    return nil;
}


- (Client *)clientWithId:(NSString *)identifier {
    for (Client *c in clients) {
        if ([c.identifier isEqualToString:identifier]) {
            return c;
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
