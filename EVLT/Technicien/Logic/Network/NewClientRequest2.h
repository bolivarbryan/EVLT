//
//  NewClient2.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 05/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest2.h"

@interface NewClientRequest : AbstractRequest

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *statut;

@property (strong, nonatomic) NSString *nom;
@property (strong, nonatomic) NSString *prenom;

@property (strong, nonatomic) NSString *numero;
@property (strong, nonatomic) NSString *rue;
@property (strong, nonatomic) NSString *code_postal;
@property (strong, nonatomic) NSString *ville;

@property (strong, nonatomic) NSString *portable;
@property (strong, nonatomic) NSString *fixe;
@property (strong, nonatomic) NSString *mail;


@end
