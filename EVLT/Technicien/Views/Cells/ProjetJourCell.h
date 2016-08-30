//
//  ProjetJourCell.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 17/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjetJourCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nomLabel;
@property (strong, nonatomic) IBOutlet UILabel *produitLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
