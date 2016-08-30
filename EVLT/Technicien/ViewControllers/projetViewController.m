//
//  projetViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 30/01/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "projetViewController.h"
#import "Projet.h"
#import "Client.h"
#import "AppDelegate.h"
#import "TECTechniciansViewController.h"
#import "detailProjetViewController.h"
#import "detailProjetBisViewController.h"

@interface projetViewController () <TECTechniciansViewControllerDelegate>

@property (strong, nonatomic) NSArray *projets;
@property (strong, nonatomic) NSArray *clients;

@end

@implementation projetViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:TECProjectsDidUpdateNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification)
    {
        [self updateProjects];
    }];
    
    [center addObserverForName:TECProjectSelectedNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification)
     {
         [self navigateToProject];
     }];
    
    [self updateProjects];
}

/*
- (void)triStatut
{
    NSMutableSet *selectedClients = [NSMutableSet set];
    
    for (Projet *p in self.projets) {
            Client *client = [self clientWithId:p.clientID];
            [selectedClients addObject:client];
    }
    
    listeAffiche = [[selectedClients allObjects] mutableCopy];
    
    NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [listeAffiche sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];
 //   [tampon addObjectsFromArray:listeAffiche];
 //   [maListe addObjectsFromArray:listeAffiche];
    [self.tableView reloadData];
    
}
 */

- (Client *)clientWithId:(NSString *)identifier {
    for (Client *c in self.clients) {
        if ([c.identifier isEqualToString:identifier]) {
            return c;
        }
    }
    return nil;
}

- (void)updateProjects {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.projets = delegate.projets;
    self.clients = delegate.clients;
    
    [self.tableView reloadData];
}

- (void)navigateToProject {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Projet *p = delegate.projectManager.selectedProject;
    [self performSegueWithIdentifier:@"showDetail" sender:p];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.projets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        Projet *projet = [self.projets objectAtIndex:indexPath.row];
    
        NSMutableSet *selectedClients = [NSMutableSet set];
        Client *client = [self clientWithId:projet.clientID];
        [selectedClients addObject:client];
        listeAffiche = [[selectedClients allObjects] mutableCopy];
    
        Client *c = [listeAffiche objectAtIndex:0];

        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", c.lastName, c.firstName];
        cell.detailTextLabel.text = projet.type;
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   /* if ([[segue identifier] isEqualToString:@"versDetailProjet"]) {
    
        detailProjetViewController *dvc = [segue destinationViewController];
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        dvc.clientSelectionne = (self.clientSelectionne);
        Projet *projet = [self.projets objectAtIndex:selectedIndex];
        dvc.chantierSelectionne = projet.identifier;
        NSLog(dvc.chantierSelectionne);
    }*/
    
    if ([segue.identifier isEqualToString:@"versDetailBis"]) {
        UINavigationController *navCtrl = (UINavigationController *)segue.destinationViewController;
        detailProjetBisViewController *dvc = (detailProjetBisViewController *)[navCtrl topViewController];
        
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];

        Projet *p = [self.projets objectAtIndex:selectedIndex];
        dvc.projet = p;
        
        NSMutableSet *selectedClients = [NSMutableSet set];
        Client *client = [self clientWithId:p.clientID];
        [selectedClients addObject:client];
        transit = [[selectedClients allObjects] mutableCopy];
        Client *c = [transit objectAtIndex:0];
        dvc.client = c;

    }
    
    if ([segue.identifier isEqualToString:@"test"]) {
        detailProjetBisViewController *dvc = [segue destinationViewController];
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        Projet *p = [self.projets objectAtIndex:selectedIndex];
        dvc.projet = p;

    }
  
    
    if ([[segue identifier] isEqualToString:@"testSegue"]) {
        
        detailProjetViewController *dvc = [segue destinationViewController];
        NSInteger selectedIndex = 4;
        dvc.clientSelectionne = (self.clientSelectionne);
        Projet *projet = [self.projets objectAtIndex:selectedIndex];
        dvc.chantierSelectionne = projet.identifier;
        NSLog(dvc.chantierSelectionne);
    }
    
    if ([segue.identifier isEqualToString:@"selectTechnician"]) {
        UINavigationController *navCtrl = (UINavigationController *)segue.destinationViewController;
        TECTechniciansViewController *ctrl = (TECTechniciansViewController *)[navCtrl topViewController];
        ctrl.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"detailProjet"]) {
        detailProjetViewController *ctrl = (detailProjetViewController *)segue.destinationViewController;
        ctrl.projet = (Projet *)sender;
    }
}

#pragma  mark - TECTechniciansViewControllerDelegate

- (void)techniciansViewController:(TECTechniciansViewController *)controller
              didSelectTechnician:(Technician *)technician {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.projectManager.technician = technician;
    [self updateProjects];
}

@end
