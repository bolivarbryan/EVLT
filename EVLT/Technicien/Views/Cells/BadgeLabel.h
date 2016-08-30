//
//  BadgeLabel.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum BadgeLabelStyle {
    BadgeLabelStyleAppIcon, // red background, white border, gloss and shadow
    BadgeLabelStyleMail     // gray background, minWidth
} BadgeLabelStyle;

@interface BadgeLabel : UILabel

@property (nonatomic) BOOL hasBorder;
@property (nonatomic) BOOL hasShadow;
@property (nonatomic) BOOL hasGloss;
@property (nonatomic) CGFloat minWidth;

- (void)setStyle:(BadgeLabelStyle)style;

@end
