//
//  ProjectDetailRequest2.h
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRequest2.h"

@interface ProjectDetailRequest : AbstractRequest

@property (strong, nonatomic) NSString *projectID;

@end
