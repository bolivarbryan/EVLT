//
//  ReseauxECSTableViewController2.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet2.h"
#import "Reseau2.h"

@interface ReseauxECSTableViewController : UITableViewController{
    
    NSMutableArray *listeAffiche;
}

@property (strong, nonatomic) NSArray *reseaux;

@property (assign, nonatomic) ReseauType reseauType;
@property (strong, nonatomic) NSString *chantierSelectionne;
@property (strong, nonatomic) Projet *projet;

@property (strong, nonatomic) NSString *statutReseau;

@end
