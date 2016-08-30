//
//  commentaireViewController.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet.h"

@interface commentaireViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Projet *projet;
@property (weak, nonatomic) IBOutlet UITextView *commentaireText;

- (IBAction)boutonValider:(id)sender;

@end
