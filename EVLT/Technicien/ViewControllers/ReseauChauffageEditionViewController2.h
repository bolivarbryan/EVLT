//
//  ReseauChauffageEditionViewController2.h
//  Commercial
//
//  Created by Benjamin Petit on 17/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reseau2.h"
#import "Projet2.h"

@interface ReseauChauffageEditionViewController : UITableViewController

@property (strong, nonatomic) Projet *projet;
@property (strong, nonatomic) Reseau *reseau;
@property (strong, nonatomic) NSString *statut;

@property (nonatomic, assign) int nombreReseaux;

@end
