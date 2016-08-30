
//
//  ClientProjectsRequest.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 04/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "ClientProjectsRequest.h"
#import "Projet.h"
#import "Client.h"
#import "TechnicianStore.h"
#import "AppDelegate.h"

@implementation ClientProjectsRequest


- (NSString *)postArguments {
    if (self.clientID.length > 0) {
        return [NSString stringWithFormat:@"client_id=%@", self.clientID];
    } else {
        return @" ";
    }
}

- (NSString *)serviceEndpoint {
    return @"import_projet.php";
}


- (id)parseObject:(id)object {
    NSMutableArray *projets = [NSMutableArray array];
    
    NSArray *jsonArray = nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDico = (NSDictionary *)object;
        jsonArray = jsonDico[@"chantiers"];
    } else if (object && [object isKindOfClass:[NSArray class]]) {
        jsonArray = (NSArray *)object;
    }
    
    for (NSDictionary *projectDetail in jsonArray) {
        Projet *projet = [Projet new];
        projet.identifier = projectDetail[@"chantier_id"];
        projet.type = projectDetail[@"type"];
        projet.statut = projectDetail[@"statut_technicien"];
        //    projet.status = [Projet statusForName:projectDetail[@"statut"]];
        projet.clientID = projectDetail[@"client_id"];
        
        [projets addObject:projet];
    }
    
    return projets;
}

@end
