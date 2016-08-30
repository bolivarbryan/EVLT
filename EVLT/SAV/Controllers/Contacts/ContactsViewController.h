//
//  ContactsViewController.h
//  EVLT
//
//  Created by bolivarbryan on 26/08/16.
//  Copyright © 2016 EVLT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
