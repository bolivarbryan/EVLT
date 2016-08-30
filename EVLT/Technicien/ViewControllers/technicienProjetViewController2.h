//
//  technicienViewController.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 05/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet2.h"

@interface technicienProjetViewController : UIViewController <UITextFieldDelegate>{
    
    NSMutableArray *commentaire;

    IBOutlet UISwitch *gaetanSwitch;
    IBOutlet UISwitch *fredSwitch;
    IBOutlet UISwitch *denisSwitch;
    IBOutlet UISwitch *vincentSwitch;
    
}

@property (strong, nonatomic) Projet *projet;

@property (strong, nonatomic) id chantierSelectionne;

@property (strong, nonatomic) id statutGaetan;
@property (strong, nonatomic) id statutFred;
@property (strong, nonatomic) id statutDenis;
@property (strong, nonatomic) id statutVincent;

- (IBAction)gaetanSwitch:(id)sender;
- (IBAction)fredSwitch:(id)sender;
- (IBAction)denisSwitch:(id)sender;
- (IBAction)vincentSwitch:(id)sender;

@end
