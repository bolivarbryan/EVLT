//
//  projetViewController.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 30/01/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface projetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *listeAffiche;
    NSMutableArray *transit;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Client *client;
@property (strong, nonatomic) id clientSelectionne;
@property (strong, nonatomic) id chantierSelectionne;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *testBouton;

@end
