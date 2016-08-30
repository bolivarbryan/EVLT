//
//  CommentaireRequest.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 30/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest.h"

@interface CommentaireRequest : AbstractRequest

@property (strong, nonatomic) NSString *projectID;
@property (strong, nonatomic) NSString *statut;
@property (strong, nonatomic) NSString *commentaire;

@end
