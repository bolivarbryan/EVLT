//
//  CoordonneesClientRequet.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "AbstractRequest.h"

@interface CoordonneesClientRequest : AbstractRequest

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *statut;

@property (strong, nonatomic) NSString *numero;
@property (strong, nonatomic) NSString *rue;
@property (strong, nonatomic) NSString *code_postal;
@property (strong, nonatomic) NSString *ville;

@end
