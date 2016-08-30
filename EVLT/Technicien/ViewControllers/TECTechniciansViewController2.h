//
//  TECTechniciansViewController2.h
//  Technicien
//
//  Created by Benjamin Petit on 26/11/2014.
//  Copyright (c) 2014 En Vert La Terre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Technician2.h"

@protocol TECTechniciansViewControllerDelegate;

@interface TECTechniciansViewController : UITableViewController

@property (assign, nonatomic) id<TECTechniciansViewControllerDelegate> delegate;

@end

@protocol TECTechniciansViewControllerDelegate <NSObject>

- (void)techniciansViewController:(TECTechniciansViewController *)controller didSelectTechnician:(Technician *)technician;

@end
