//
//  projetsJourTableViewController.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 17/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface projetsJourTableViewController : UITableViewController{
    NSMutableArray *listeAffiche;
    NSMutableArray *transitProjet;
    NSMutableArray *transitClient;
    NSArray *clients;
    NSArray *projets;
}

@property (strong, nonatomic) NSArray *projetsID;

@property (strong, nonatomic) NSDate *dateActive;


@end
