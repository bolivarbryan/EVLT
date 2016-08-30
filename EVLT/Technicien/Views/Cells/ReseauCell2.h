//
//  ReseauCell2.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReseauCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *existingLabel;
@property (strong, nonatomic) IBOutlet UILabel *existLabel;
@property (strong, nonatomic) IBOutlet UILabel *radiateursLabel;
@property (strong, nonatomic) IBOutlet UILabel *materiauLabel;
@property (strong, nonatomic) IBOutlet UILabel *diameterLabel;

@end
