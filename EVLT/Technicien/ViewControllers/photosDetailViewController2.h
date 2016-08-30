//
//  photosDetailViewController2.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 17/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photosDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,  UITextFieldDelegate>{
    
    UIImagePickerController *picker;
    int compteur;
    
    IBOutlet UIBarButtonItem *boutonAjout;
    IBOutlet UIImageView *photo;
    
    NSMutableArray *listeProjets;
    
    __weak IBOutlet UITextField *commentaire;
}

@property (strong, nonatomic) id statut;
@property (strong, nonatomic) id ligne;
@property (strong, nonatomic) id photoID;
@property (strong, nonatomic) id chantierSelectionne;

@property (weak, nonatomic) IBOutlet UITextField *commentairePhoto;



@property (strong, nonatomic) IBOutlet UISegmentedControl *choix;
@property (strong, nonatomic) NSString *photoStr;

@end
