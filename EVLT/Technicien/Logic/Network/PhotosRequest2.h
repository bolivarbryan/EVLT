//
//  PhotosRequest2.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "AbstractRequest2.h"

@interface PhotosRequest : AbstractRequest

@property (strong, nonatomic) NSString *projectID;
@property (strong, nonatomic) NSString *statut;
@property (strong, nonatomic) NSString *commentaire;
@property (strong, nonatomic) NSString *url;

@end

