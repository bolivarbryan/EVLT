//
//  ReseauxRequest.m
//  Commercial
//
//  Created by Benjamin Petit on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "ReseauxRequest2.h"
#import "Reseau2.h"

@implementation ReseauxRequest

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"chantier_id=%@&action=%@&reseau_id=%@&type=%@&nom=%@&existe=%@&radiateur=%@&cuivre=%@&diametre=%@", self.projectID, self.action, self.reseauID, self.type, self.nom, self.existe, self.radiateur, self.cuivre, self.diametre];
}

- (NSString *)serviceEndpoint {
    return @"reseaux_projet.php";
}

- (id)parseObject:(id)object {
    NSMutableArray *reseaux = [NSMutableArray array];
    
    if (object && [object isKindOfClass:[NSArray class]]) {
        NSArray *jsonArray = (NSArray *)object;
        for (NSDictionary *reseauJSON in jsonArray) {
            Reseau *r = [Reseau new];
            r.name = reseauJSON[@"nom_reseau"];
            r.identifier = reseauJSON[@"reseau_id"];
            r.existing = reseauJSON[@"reseau_existant"];
            r.radiateurs = reseauJSON[@"reseau_radiateur"];
            r.material = reseauJSON[@"reseau_cuivre"];
            r.diameter = reseauJSON[@"reseau_diametre"];
            NSString *rType = reseauJSON[@"type_reseau"];
            r.type = [rType isEqualToString:@"chauffage"] ? ReseauTypeChauffage : ReseauTypeECS;
            
            [reseaux addObject:r];
        }
        
    }
    
    return reseaux;
}

@end
