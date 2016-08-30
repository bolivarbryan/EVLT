//
//  CommentaireRequest.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 30/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "CommentaireRequest.h"
#import "Projet.h"

@implementation CommentaireRequest


- (NSString *)postArguments {
    return [NSString stringWithFormat:@"chantier_id=%@&statut=%@&commentaire=%@", self.projectID, self.statut, self.commentaire];
}

- (NSString *)serviceEndpoint {
    return @"commentaires.php";
}

- (id)parseObject:(id)object {
    Projet *projet = nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dico = (NSDictionary *)object;
        projet = [Projet new];
        projet.note = dico[@"commentaire"];
        
    }
    
    return projet;
}

@end

