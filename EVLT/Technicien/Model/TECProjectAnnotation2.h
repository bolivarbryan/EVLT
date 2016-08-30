//
//  TECProjectAnnotation2.h
//  Technicien
//
//  Created by Benjamin Petit on 27/11/2014.
//  Copyright (c) 2014 En Vert La Terre. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Projet2.h"

//@interface TECProjectAnnotation : MKAnnotationView
@interface TECProjectAnnotation : MKPointAnnotation

@property (strong, nonatomic) Projet *project;

@end
