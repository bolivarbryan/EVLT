//
//  projetsJourTableViewController.m
//  Technicien
//
//  Created by Emmanuel Levasseur on 17/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "projetsJourTableViewController2.h"
#import "detailProjetBisViewController2.h"
#import "ProjectforDate2.h"
#import "AppDelegate.h"
#import "Client2.h"
#import "Projet2.h"
#import "ProjetJourCell2.h"


@implementation projetsJourTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSDateFormatter *miseEnForme = [[NSDateFormatter alloc] init];
    [miseEnForme setTimeStyle:NSDateFormatterNoStyle];
    [miseEnForme setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [miseEnForme setLocale:frLocale];
    NSString *dateAffichee = [NSString stringWithFormat:@"%@", [miseEnForme stringFromDate:self.dateActive]];

    self.title = [NSString stringWithFormat:@"%@", dateAffichee];
    
    [self updateProjects];

}

- (void)updateProjects {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    projets = delegate.projets;
    clients = delegate.clients;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.projetsID count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    ProjetJourCell *cell = (ProjetJourCell *)[tableView dequeueReusableCellWithIdentifier:@"projetJourCell" forIndexPath:indexPath];
 
    ProjectforDate *p = [self.projetsID objectAtIndex:indexPath.row];
    
    NSMutableSet *selectedProject = [NSMutableSet set];
    NSMutableSet *selectedClient = [NSMutableSet set];
    
    Projet *p2 = [self projetWithId:p.identifier];
    [selectedProject addObject:p2];
    
    Client *c2 = [self clientWithId:p2.clientID];
    [selectedClient addObject:c2];
    
    NSDate *dateFin = [p.dateDebut dateByAddingTimeInterval:60*60*24*(p.duree-1)];
    NSDateFormatter *miseEnForme = [[NSDateFormatter alloc] init];
    [miseEnForme setTimeStyle:NSDateFormatterNoStyle];
    [miseEnForme setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [miseEnForme setLocale:frLocale];
    NSString *dateDebutProjet = [NSString stringWithFormat:@"%@", [miseEnForme stringFromDate:p.dateDebut]];
    NSString *dateFinProjet = [NSString stringWithFormat:@"%@", [miseEnForme stringFromDate:dateFin]];
    
    cell.nomLabel.text = [NSString stringWithFormat:@"%@ %@", c2.lastName, c2.firstName];
    cell.produitLabel.text = p2.type;
    
    if (p.duree == 1) {
        cell.dateLabel.text = [NSString stringWithFormat:@"Chantier prévu le %@", dateDebutProjet];
    }
    if (p.duree > 1) {
    cell.dateLabel.text = [NSString stringWithFormat:@"Chantier prévu du %@ au %@", dateDebutProjet, dateFinProjet];
    }
    
    return cell;
}

- (Projet *)projetWithId:(NSString *)identifier {
    for (Projet *p in projets) {
        if ([p.identifier isEqualToString:identifier]) {
            return p;
        }
    }
    return nil;
}

- (Client *)clientWithId:(NSString *)identifier {
    for (Client *c in clients) {
        if ([c.identifier isEqualToString:identifier]) {
            return c;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"versDetails"]) {
        UINavigationController *navCtrl = (UINavigationController *)segue.destinationViewController;
        detailProjetBisViewController *dvc = (detailProjetBisViewController *)[navCtrl topViewController];
        
       NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
       
       ProjectforDate *p = [self.projetsID objectAtIndex:selectedIndex];
       
       NSMutableSet *ProjetEnvoye = [NSMutableSet set];
       Projet *p3 = [self projetWithId:p.identifier];
       [ProjetEnvoye addObject:p3];
       transitProjet = [[ProjetEnvoye allObjects] mutableCopy];
       Projet *pro = [transitProjet objectAtIndex:0];
       dvc.projet = pro;
     
        NSMutableSet *selectedClients = [NSMutableSet set];
        Client *client = [self clientWithId:pro.clientID];
        [selectedClients addObject:client];
        transitClient = [[selectedClients allObjects] mutableCopy];
        Client *c = [transitClient objectAtIndex:0];
        dvc.client = c;
        
    }
}


@end
