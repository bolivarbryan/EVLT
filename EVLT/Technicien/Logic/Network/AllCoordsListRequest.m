
//
//  ClientProjectsRequest.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 04/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "ClientProjectsRequest.h"
#import "AllCoordsListRequest.h"
#import "Projet.h"
#import "Client.h"
#import "TechnicianStore.h"
#import "AppDelegate.h"

@implementation AllCoordsListRequest


- (NSString *)postArguments {
        return [NSString stringWithFormat:@"statut_id=%@", self.statut];
}

- (NSString *)serviceEndpoint {
    return @"import_allCoords.php";
}


- (id)parseObject:(id)object {
    NSMutableArray *projets = [NSMutableArray array];
    if (object && [object isKindOfClass:[NSArray class]]) {
        NSArray *jsonArray = (NSArray *)object;
        for (NSDictionary *projectDetail in jsonArray) {
        Projet *projet = [Projet new];
        projet.identifier = projectDetail[@"chantier_id"];
        projet.numero = projectDetail[@"numero"];
        projet.rue = projectDetail[@"rue"];
        projet.code_postal = projectDetail[@"code_postal"];
        projet.ville = projectDetail[@"ville"];
        projet.latitude = [projectDetail[@"latitude"] floatValue];
        projet.longitude = [projectDetail[@"longitude"] floatValue];
        
        [projets addObject:projet];
        }
    }
    
    return projets;
}


@end
