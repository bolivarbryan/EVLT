//
//  Photo.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *commentaire;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSData *data;

//NSData *data

@end
