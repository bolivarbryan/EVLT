//
//  NewClient.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 05/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "NewClientRequest2.h"
#import "Client2.h"

@implementation NewClientRequest

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"nom=%@&prenom=%@&numero=%@&rue=%@&codePostal=%@&ville=%@&telFixe=%@&telPortable=%@&email=%@", self.nom, self.prenom, self.numero, self.rue, self.code_postal, self.ville, self.portable, self.fixe, self.mail];
}

- (NSString *)serviceEndpoint {
    return @"nouveau_client.php";
}

- (id)parseObject:(id)object {
    Client *client= nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dico = (NSDictionary *)object;
        client = [Client new];
        client.identifier = dico[@"client_id"];
        client.lastName = dico[@"nom"];
        client.firstName = dico[@"prenom"];
        NSString *status = dico[@"commercial_actif"];
        client.commercialActive = [status isEqualToString:@"OUI"];
        
    }
    
    return client;
}

@end
