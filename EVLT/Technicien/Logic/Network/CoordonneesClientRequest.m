//
//  CoordonneesClientRequet.m
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "CoordonneesClientRequest.h"
#import "Client.h"

@implementation CoordonneesClientRequest

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"client_id=%@", self.clientID];
}

- (NSString *)serviceEndpoint {
    return @"coordonnees_client.php";
}

- (id)parseObject:(id)object {
    NSMutableArray *clients = [NSMutableArray array];
    
    NSArray *jsonArray = nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDico = (NSDictionary *)object;
        jsonArray = jsonDico[@"clients"];
    } else if (object && [object isKindOfClass:[NSArray class]]) {
        jsonArray = (NSArray *)object;
    }
    
    for (NSDictionary *projectDetail in jsonArray) {
        Client *client = [Client new];
        client.identifier = projectDetail[@"client_id"];
        client.numero = projectDetail[@"numero"];
        client.rue = projectDetail[@"rue"];
        client.code_postal = projectDetail[@"code_postal"];
        client.ville = projectDetail[@"ville"];
        client.mobilePhone = projectDetail[@"tel_portable"];
        client.phone = projectDetail[@"tel_fixe"];
        client.email = projectDetail[@"email"];
        
        [clients addObject:client];
    }
    
    return clients;
}

@end

