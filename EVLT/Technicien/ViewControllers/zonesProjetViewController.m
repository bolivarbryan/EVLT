//
//  zonesProjetViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 24/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "zonesProjetViewController.h"

@interface zonesProjetViewController ()

@end

@implementation zonesProjetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    nbZones = 1;
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nbZones;
}

/*

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    return cell;
}


-(void)refreshTableView
{
    [self.tableView refresh];
}
 */

- (IBAction)nombreChauffage:(id)sender {
}

- (IBAction)nombreECS:(id)sender {
}

- (IBAction)ajoutZone:(id)sender {
    
    nbZones = nbZones +1;
    
  //  NSLog(@"%@",nbZones);
    
[self.tableView reloadData];
    
}
@end
