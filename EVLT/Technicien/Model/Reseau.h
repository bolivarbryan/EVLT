//
//  Reseau.h
//  Commercial
//
//  Created by Benjamin Petit on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    ReseauTypeECS = 0,
    ReseauTypeChauffage
} ReseauType;

@interface Reseau : NSObject

@property (strong, nonatomic) NSString *statut;
@property (strong, nonatomic) NSString *identifier;
@property (assign, nonatomic) ReseauType type;
@property (strong, nonatomic) NSString *typebis;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *existing;
@property (strong, nonatomic) NSString *radiateurs;
@property (strong, nonatomic) NSString *material;
@property (strong, nonatomic) NSString *diameter;

@end
