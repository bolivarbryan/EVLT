//
//  ProjectDetailRequest.m
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "ProjectDetailRequest2.h"
#import "Projet2.h"

@interface ProjectDetailRequest()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ProjectDetailRequest

#pragma mark - Accessors

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"YYYY-MM-dd";
        self.dateFormatter = f;
    }
    return _dateFormatter;
}

#pragma mark - Subclassing

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"chantier_id=%@", self.projectID];
}

- (NSString *)serviceEndpoint {
    return @"import_detail_projet.php";
}

- (id)parseObject:(id)object {
    Projet *projet = nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dico = (NSDictionary *)object;
        projet = [Projet new];
        projet.identifier = dico[@"chantier_id"];
        projet.numero = dico[@"numero"];
        projet.rue = dico[@"rue"];
        projet.code_postal = dico[@"code_postal"];
        projet.ville = dico[@"ville"];
        projet.note = dico[@"commentaire"];
        
        //VOIR SI FORMAT DE DONNEE OK
        //  projet.test = dico[@"duree_chantier"];
        projet.numberOfTime = dico[@"duree_chantier"];
        projet.unitOfTime = dico[@"unite_temps"];
        NSString *dateString = dico[@"date"];
        projet.startDate = [self.dateFormatter dateFromString:dateString];
        
    }
    
    return projet;
}

@end
