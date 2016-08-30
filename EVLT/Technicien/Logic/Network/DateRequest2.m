//
//  DateRequest.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "DateRequest2.h"
#import "Projet2.h"

@interface DateRequest()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DateRequest


- (NSString *)postArguments {
    return [NSString stringWithFormat:@"chantier_id=%@&statut=%@&date=%@&duree=%@", self.projectID, self.statut, self.date, self.duree];
}

- (NSString *)serviceEndpoint {
    return @"date.php";
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"YYYY-MM-dd";
        self.dateFormatter = f;
    }
    return _dateFormatter;
}

- (id)parseObject:(id)object {
    Projet *projet = nil;
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dico = (NSDictionary *)object;
        projet = [Projet new];
        projet.numberOfTime = dico[@"duree_chantier"];
        NSString *dateString = dico[@"date"];
        projet.startDate = [self.dateFormatter dateFromString:dateString];
        
    }
    
    return projet;
}


@end