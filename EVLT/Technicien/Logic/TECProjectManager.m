//
//  TECProjectManager.m
//  Technicien
//
//  Created by Benjamin Petit on 26/11/2014.
//  Copyright (c) 2014 En Vert La Terre. All rights reserved.
//

#import "TECProjectManager.h"
#import "Communicator.h"
#import "ClientsListRequest.h"
#import "ClientProjectsRequest.h"
#import "AllCoordsListRequest.h"
#import "Projet.h"

NSString * const TECProjectsDidUpdateNotification = @"TECProjectsDidUpdateNotification";
NSString * const TECProjectSelectedNotification = @"TECProjectSelectedNotification";

@interface TECProjectManager ()

@property (strong, nonatomic) NSArray *filteredProjects;

@end

@implementation TECProjectManager

- (void)setProjects:(NSArray *)projects {
    if (projects != _projects) {
        _projects = projects;
        self.filteredProjects = [self projectsForTechnician:self.technician];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:TECProjectsDidUpdateNotification object:nil];
    }
}

- (void)setSelectedProject:(Projet *)selectedProject {
    if (_selectedProject != selectedProject) {
        _selectedProject = selectedProject;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:TECProjectsDidUpdateNotification object:nil];
    }
}

- (void)setTechnician:(Technician *)technician {
    if (_technician != technician) {
        _technician = technician;
        self.filteredProjects = [self projectsForTechnician:technician];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:TECProjectsDidUpdateNotification object:nil];
    }
}

- (void)updateProjects {
  //  NSLog(@"FONCTION UPDATE PROJETS LANCEE");
    Communicator *c = [[Communicator alloc] init];
    ClientProjectsRequest *request = [[ClientProjectsRequest alloc] init];
    self.projects = [c performRequest:request];
    
    NSMutableSet *selectedProjects = [NSMutableSet set];
    for (Projet *p in self.projects) {

        if( [p.statut isEqualToString:@"Prevu"])
           {
             [selectedProjects addObject:p];
           }
        if( [p.statut isEqualToString:@"En cours"])
        {
            [selectedProjects addObject:p];
        }
        if( [p.statut isEqualToString:@"A finir"])
        {
            [selectedProjects addObject:p];
        }
        if( [p.statut isEqualToString:@"Urgence"])
        {
            [selectedProjects addObject:p];
        }
    }
    
    self.projects = [[selectedProjects allObjects] mutableCopy];
}

- (void)updateClients {
    //  NSLog(@"FONCTION UPDATE CLIENTS LANCEE");
    Communicator *c = [[Communicator alloc] init];
    ClientsListRequest *request = [[ClientsListRequest alloc] init];
    self.clients = [c performRequest:request];
    //   NSLog(@"CLIENTS : %@", self.clients);
}

- (void)updateAllCoords {
  //  NSLog(@"FONCTION UPDATE COORDONNEES LANCEE");
    Communicator *c = [[Communicator alloc] init];
    AllCoordsListRequest *request = [[AllCoordsListRequest alloc] init];
    self.coords = [c performRequest:request];
   // NSLog(@"COORDONNEES : %@", self.coords);
}

- (NSArray *)projectsForTechnician:(Technician *)technician {
    NSArray *filteredProjects = nil;
    if (technician) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            Projet *p = (Projet *)evaluatedObject;
            return [p.technicians containsObject:technician];
        }];
        filteredProjects = [self.projects filteredArrayUsingPredicate:predicate];
    } else {
        filteredProjects = self.projects;
    }
    return filteredProjects;
}

/*
- (Projet *)projetWithId:(NSString *)identifier {
    for (Client *c in self.clients) {
        if ([c.identifier isEqualToString:identifier]) {
            return c;
        }
    }
    return nil;
}
*/
 
- (NSArray *)projectsForCurrentTechnician {
    // return self.filteredProjects;
    return self.projects;
}

- (NSArray *)clientsForCurrentTechnician {
    // return self.filteredProjects;
    return self.clients;
}



@end
