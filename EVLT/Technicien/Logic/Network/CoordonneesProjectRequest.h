//
//  CoordonneesProjectRequest.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 30/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest.h"

@interface CoordonneesProjectRequest : AbstractRequest

@property (strong, nonatomic) NSString *projectID;
@property (strong, nonatomic) NSString *statut;

@property (strong, nonatomic) NSString *numero;
@property (strong, nonatomic) NSString *rue;
@property (strong, nonatomic) NSString *code_postal;
@property (strong, nonatomic) NSString *ville;

@end
