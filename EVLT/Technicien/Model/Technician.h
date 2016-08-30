//
//  Technician.h
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Technician : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* tableName;

- (instancetype)initWithName:(NSString *)name;

@end
