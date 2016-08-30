//
//  TechnicianStore.h
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Technician.h"

@interface TechnicianStore : NSObject

- (NSArray *)availableTechnicians;
- (Technician *)technicianForName:(NSString *)name;

@end
