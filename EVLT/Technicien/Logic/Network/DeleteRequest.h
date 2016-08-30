//
//  DeleteRequest.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 13/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest.h"

@interface DeleteRequest : AbstractRequest

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *statut;

@end
