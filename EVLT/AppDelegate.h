//
//  AppDelegate.h
//  EVLT
//
//  Created by bolivarbryan on 25/08/16.
//  Copyright © 2016 EVLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TechnicianStore2.h"
#import "TECProjectManager2.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) TechnicianStore *technicianStore;
@property (strong, nonatomic) TECProjectManager *projectManager;

@property (strong, nonatomic) NSArray *projets;
@property (strong, nonatomic) NSArray *clients;
@property (strong, nonatomic) NSArray *coords;

@end

