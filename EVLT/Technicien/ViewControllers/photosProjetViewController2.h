//
//  photosProjetViewController2.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 10/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet2.h"
#import "DropboxManager2.h"
#import "Photo2.h"

@interface photosProjetViewController : UITableViewController <DropBoxDelegate>{
    DropboxManager *objManager;
    NSMutableArray *listePhotos;
    NSMutableArray *listeProjets;
}

@property (nonatomic,strong) DropboxManager *objManager;
@property (nonatomic, strong) DBRestClient *restClient;

@property (strong, nonatomic) Projet *projet;

@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) id chantierSelectionne;

@property (strong, nonatomic) NSString *urlPhoto;
@property (strong, nonatomic) NSString *urlTemp;

@property (strong, nonatomic) UIImage *TestImage;

@end
