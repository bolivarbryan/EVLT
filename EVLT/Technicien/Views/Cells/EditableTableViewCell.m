//
//  EditableTableViewCell.m
//  Commercial
//
//  Created by Benjamin Petit on 19/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "EditableTableViewCell.h"

@implementation EditableTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel = view;
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *view = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField = view;
    }
    return _textField;
}

@end
