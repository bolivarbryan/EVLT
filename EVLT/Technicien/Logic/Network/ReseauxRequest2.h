//
//  ReseauxRequest2.h
//  Commercial
//
//  Created by Benjamin Petit on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest2.h"

@interface ReseauxRequest : AbstractRequest

@property (strong, nonatomic) NSString *projectID;
@property (strong, nonatomic) NSString *reseauID;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *statut;
@property (strong, nonatomic) NSString *action;

@property (strong, nonatomic) NSString *nom;
@property (strong, nonatomic) NSString *existe;
@property (strong, nonatomic) NSString *radiateur;
@property (strong, nonatomic) NSString *cuivre;
@property (strong, nonatomic) NSString *diametre;

@end
