//
//  PhotosRequest.m
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "PhotosRequest2.h"
#import "Photo2.h"


@implementation PhotosRequest

- (NSString *)postArguments {
    return [NSString stringWithFormat:@"chantier_id=%@&statut=%@&commentaire=%@&photoID=%@", self.projectID, self.statut, self.commentaire, self.url];
}

- (NSString *)serviceEndpoint {
    return @"photo_projet.php";
}

- (id)parseObject:(id)object {
    NSMutableArray *photos = [NSMutableArray array];
    
    if (object && [object isKindOfClass:[NSArray class]]) {
        NSArray *jsonArray = (NSArray *)object;
        for (NSDictionary *reseauJSON in jsonArray) {
            
            Photo *p = [Photo new];
            p.identifier = reseauJSON[@"photos_chantier_id"];
            p.url = reseauJSON[@"url_photo"];
            p.commentaire = reseauJSON[@"commentaire_photo"];
            
            // NSLog(@"CARAC : %@ %@", p.url, p.commentaire);
            
            [photos addObject:p];
        }
        
    }
    
    return photos;
}

@end
