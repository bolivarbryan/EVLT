//
//  ClientProjectsRequest.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 04/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest.h"

@interface ClientProjectsRequest : AbstractRequest

@property (strong, nonatomic) NSString *clientID;

@end
