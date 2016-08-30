//
//  ReseauxECSTableViewController.m
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "ReseauxECSTableViewController2.h"
#import "ReseauCell2.h"
#import "Reseau2.h"
#import "Communicator2.h"
#import "ReseauxRequest2.h"
#import "Projet2.h"
#import "DeleteRequest2.h"

@interface ReseauxECSTableViewController ()

@property (strong, nonatomic) NSArray *allProjects;

@end

@implementation ReseauxECSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self importerDonnees];
}

- (void)importerDonnees
{
    
    NSMutableArray*listeCharge = [[NSMutableArray alloc] init];
    
    for(Reseau *res in self.reseaux)
    {
        [listeCharge addObject:res];
    }
    listeAffiche = listeCharge;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listeAffiche.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReseauCell *cell = (ReseauCell *)[tableView dequeueReusableCellWithIdentifier:@"reseauCell" forIndexPath:indexPath];
    
    Reseau *r = [listeAffiche objectAtIndex:indexPath.row];
    cell.nameLabel.text = r.name;
    cell.existingLabel.text = [NSString stringWithFormat:@"Réseau %@", r.existing];
    cell.materiauLabel.text = [NSString stringWithFormat:@"Réseau en %@", r.material];
    cell.diameterLabel.text = [NSString stringWithFormat:@"Diamètre : %@", r.diameter];
    return cell;
    
}

@end

