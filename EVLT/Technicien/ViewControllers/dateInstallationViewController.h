//
//  dateInstallationViewController.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet.h"

@interface dateInstallationViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) Projet *projet;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateInstallation;

//- (IBAction)dateChange:(id)sender;

@property (strong, nonatomic) id dateChoisie;
@property (strong, nonatomic) id chantierSelectionne;
@property (weak, nonatomic) IBOutlet UIPickerView *uniteTemps;

@property (weak, nonatomic) IBOutlet UITextField *dureeLabel;
@property (weak, nonatomic) IBOutlet UILabel *litteralDureeLabel;


- (IBAction)boutonValider:(id)sender;


@end
