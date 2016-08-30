//
//  TECProjectManager2.h
//  Technicien
//
//  Created by Benjamin Petit on 26/11/2014.
//  Copyright (c) 2014 En Vert La Terre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Technician2.h"
#import "Projet2.h"

extern NSString * const TECProjectsDidUpdateNotification;
extern NSString * const TECProjectSelectedNotification;

@interface TECProjectManager : NSObject

@property (strong, nonatomic) NSArray *projects;
@property (strong, nonatomic) NSArray *clients;
@property (strong, nonatomic) NSArray *coords;
@property (strong, nonatomic) Technician *technician;
@property (strong, nonatomic) Projet *selectedProject;

- (void)updateProjects;
- (void)updateClients;
- (void)updateAllCoords;

- (NSArray *)projectsForCurrentTechnician;
- (NSArray *)clientsForCurrentTechnician;

@end
