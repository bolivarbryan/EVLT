//
//  EditableTableViewCell.h
//  Commercial
//
//  Created by Benjamin Petit on 19/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end
