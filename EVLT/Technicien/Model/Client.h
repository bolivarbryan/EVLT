//
//  Client.h
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* firstName;

@property (strong, nonatomic) NSString *numero;
@property (strong, nonatomic) NSString *rue;
@property (strong, nonatomic) NSString *code_postal;
@property (strong, nonatomic) NSString *ville;

@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSString* mobilePhone;
@property (strong, nonatomic) NSArray* projects;
@property (assign, nonatomic) BOOL commercialActive;

@end
