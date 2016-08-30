//
//  CoordonneesProjectRequest.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 30/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "CoordonneesProjectRequest.h"
#import "Projet.h"

@implementation CoordonneesProjectRequest

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"chantier_id=%@&statut=%@&numero=%@&rue=%@&codePostal=%@&ville=%@", self.projectID, self.statut, self.numero, self.rue, self.code_postal, self.ville];
}

- (NSString *)serviceEndpoint {
    return @"coordonnees_chantier.php";
}

- (id)parseObject:(id)object {
    Projet *projet = nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dico = (NSDictionary *)object;
        projet = [Projet new];
        projet.numero = dico[@"numero"];
        projet.rue = dico[@"rue"];
        projet.code_postal = dico[@"code_postal"];
        projet.ville = dico[@"ville"];
        
    }
    
    return projet;
}

@end
