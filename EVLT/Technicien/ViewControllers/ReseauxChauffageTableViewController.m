//
//  ReseauxChauffageTableViewController.m
//  Commercial
//
//  Created by Benjamin Petit on 03/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "ReseauxChauffageTableViewController.h"
#import "ReseauCell.h"
#import "Reseau.h"
#import "Communicator.h"
#import "ReseauxRequest.h"
#import "Projet.h"
#import "ReseauChauffageEditionViewController.h"
#import "DeleteRequest.h"

@interface ReseauxChauffageTableViewController ()

@property (strong, nonatomic) NSArray *allProjects;

@end

@implementation ReseauxChauffageTableViewController

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
    cell.radiateursLabel.text = [NSString stringWithFormat:@"Emetteurs : %@", r.radiateurs];
    cell.materiauLabel.text = [NSString stringWithFormat:@"Réseau en %@", r.material];
    cell.diameterLabel.text = [NSString stringWithFormat:@"Diamètre : %@", r.diameter];
    return cell;
    
}

@end