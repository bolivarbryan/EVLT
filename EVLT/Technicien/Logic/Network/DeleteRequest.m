//
//  DeleteRequest.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 13/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "DeleteRequest.h"

@implementation DeleteRequest

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"ID=%@&statut=%@", self.ID, self.statut];
}

- (NSString *)serviceEndpoint {
    return @"nouveau_client.php";
}

@end
