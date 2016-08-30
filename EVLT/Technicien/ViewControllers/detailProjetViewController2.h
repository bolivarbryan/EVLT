//
//  detailprojetViewController2.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Projet2.h"
#import "AddressCell2.h"

@interface detailProjetViewController : UITableViewController

//@property (nonatomic,assign) DropboxManager *objManager;
//@property (nonatomic, strong) DBRestClient *restClient;

@property (strong, nonatomic) Projet *projet;
@property (strong, nonatomic) id clientSelectionne;
@property (strong, nonatomic) id chantierSelectionne;

@property (strong, nonatomic) NSArray *zones;
@property (strong, nonatomic) NSArray *reseaux;
@property (strong, nonatomic) NSArray *photos;
@property (assign, nonatomic) double duree;

@property (strong, nonatomic) IBOutlet AddressCell *addressCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *zoneCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *heatingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *waterCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *commCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *techCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *statusCell;

@end

