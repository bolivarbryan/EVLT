//
//  tachesProjetViewController.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 10/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet.h"

@interface tachesProjetViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
NSMutableArray *maListe;
NSMutableArray *commentaire;
}

@property (strong, nonatomic) Projet *projet;
@property (strong, nonatomic) id chantierSelectionne;
@property (weak, nonatomic) IBOutlet UITextField *tempsText;
@property (weak, nonatomic) IBOutlet UIPickerView *uniteTemps;

- (IBAction)ajoutLigne:(id)sender;

@end
