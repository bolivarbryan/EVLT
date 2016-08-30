//
//  TechnicianStore.m
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "TechnicianStore2.h"

@interface TechnicianStore()

@property (strong, nonatomic) NSArray* technicians;

@end

@implementation TechnicianStore

#pragma mark - API

- (NSArray *)availableTechnicians {
    return self.technicians;
}

#pragma mark - Accessors

- (NSArray *)technicians {
    if (!_technicians) {
        Technician *denis = [[Technician alloc] initWithName:@"Denis"];
        Technician *gaetan = [[Technician alloc] initWithName:@"Gaëtan"];
        Technician *fred = [[Technician alloc] initWithName:@"Fred"];
        Technician *vincent = [[Technician alloc] initWithName:@"Vincent"];
        
        self.technicians = @[denis, gaetan, fred, vincent];
    }
    return _technicians;
}

- (Technician *)technicianForName:(NSString *)name {
    Technician *tech = nil;
    
    for (Technician *knownTech in self.technicians) {
        NSComparisonResult r = [knownTech.name compare:name
                                               options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
        if (r == NSOrderedSame) {
            tech = knownTech;
        }
    }
    
    return tech;
}

@end
