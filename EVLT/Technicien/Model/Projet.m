//
//  Projet.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 28/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "Projet.h"

@implementation Projet

+ (NSString *) nameForStatus:(int)status {
    NSString *name = @"Statut inconnu";
    switch (status) {
        case 0:
            name = @"Visite technique faite";
            break;
        case 1:
            name = @"Devis envoyé";
            break;
        case 2:
            name = @"Devis accepté";
            break;
        case 3:
            name = @"Inactif";
            break;
    }
    return name;
}

- (NSString *)addressString {
    NSMutableArray *addressArray = [NSMutableArray array];
    if (self.numero.length) {
        [addressArray addObject:self.numero];
    }
    if (self.rue.length) {
        [addressArray addObject:self.rue];
    }
    if (self.code_postal.length) {
        [addressArray addObject:self.code_postal];
    }
    if (self.ville.length) {
        [addressArray addObject:self.ville];
    }
    
    return [addressArray componentsJoinedByString:@", "];
}

@end
