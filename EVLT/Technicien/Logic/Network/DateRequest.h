//
//  DateRequest.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest.h"

@interface DateRequest : AbstractRequest

@property (strong, nonatomic) NSString *projectID;
@property (strong, nonatomic) NSString *statut;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *duree;

@end
