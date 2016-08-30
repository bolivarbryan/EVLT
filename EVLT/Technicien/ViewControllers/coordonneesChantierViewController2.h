//
//  coordonneesChantierViewController2.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 04/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Projet2.h"

@interface coordonneesChantierViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>{
    CLLocationManager* locationManager;
    NSMutableArray *commentaire;
}

@property (strong, nonatomic) Projet *projet;

@property (strong, nonatomic) id latitude;
@property (strong, nonatomic) id longitude;

@property (weak, nonatomic) IBOutlet UITextView *commentaireText;

@property (weak, nonatomic) IBOutlet UITextField *numeroText;

@property (weak, nonatomic) IBOutlet UITextField *rueText;

@property (weak, nonatomic) IBOutlet UITextField *codePostalText;

@property (weak, nonatomic) IBOutlet UITextField *villeText;

//- (IBAction)geolocalise:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *geolocalisationSwitch;

@property (strong, nonatomic) IBOutlet UILabel *geolocalisationOK;

@property (strong, nonatomic) IBOutlet UILabel *geolocalisationText;

- (IBAction)boutonValider:(id)sender;

@end
