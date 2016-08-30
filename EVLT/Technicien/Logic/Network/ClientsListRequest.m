//
//  ClientsListRequest.m
//  Commercial
//
//  Created by Benjamin Petit on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "ClientsListRequest.h"
#import "Client.h"

@implementation ClientsListRequest

- (NSString *)postArguments {
    return nil;
}

- (NSString *)serviceEndpoint {
    return @"remplissage_accueil.php";
}

- (id)parseObject:(id)object {
    NSMutableArray *clients = [NSMutableArray array];
    if (object && [object isKindOfClass:[NSArray class]]) {
        NSArray *jsonArray = (NSArray *)object;
        for (NSDictionary *clientDetail in jsonArray) {
            Client *client = [Client new];
            client.identifier = clientDetail[@"client_id"];
            client.lastName = clientDetail[@"nom"];
            client.firstName = clientDetail[@"prenom"];
            NSString *status = clientDetail[@"commercial_actif"];
            client.commercialActive = [status isEqualToString:@"OUI"];
            
            [clients addObject:client];
        }
    }
    
    return clients;
}


@end
