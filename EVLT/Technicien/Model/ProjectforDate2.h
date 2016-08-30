//
//  ProjectforDate2.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 16/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectforDate : NSObject

@property (strong, nonatomic) NSDate *dateActive;

@property (strong, nonatomic) NSDate *dateDebut;
@property (assign, nonatomic) int duree;

@property (strong, nonatomic) NSString *identifier;

@end
