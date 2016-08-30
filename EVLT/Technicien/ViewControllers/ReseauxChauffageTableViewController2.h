//
//  ReseauxChauffageTableViewController2.h
//  Commercial
//
//  Created by Benjamin Petit on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet2.h"
#import "Reseau2.h"

@interface ReseauxChauffageTableViewController : UITableViewController{
    
    NSMutableArray *listeAffiche;
}

@property (strong, nonatomic) NSArray *reseaux;

@property (assign, nonatomic) ReseauType reseauType;
@property (strong, nonatomic) NSString *chantierSelectionne;
@property (strong, nonatomic) Projet *projet;

@property (strong, nonatomic) NSString *statutReseau;

@end
