//
//  detailProjetViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//


#import "detailProjetViewController.h"
#import "commentaireViewController.h"
#import "coordonneesChantierViewController.h"
#import "technicienProjetViewController.h"
//#import "statutProjetViewController.h"
#import "photosProjetViewController.h"
#import "tachesProjetViewController.h"
#import "dateInstallationViewController.h"
#import "Communicator.h"
#import "ProjectDetailRequest.h"
#import "ReseauxRequest.h"
#import "ReseauxChauffageTableViewController.h"
#import "Reseau.h"

@interface detailProjetViewController ()

@end

@implementation detailProjetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self communication];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)communication {
    
    ProjectDetailRequest *request = [[ProjectDetailRequest alloc] init];
    request.projectID = self.chantierSelectionne;
    Communicator *comm = [[Communicator alloc] init];
    self.projet = (Projet *)[comm performRequest:request];
    
    ReseauxRequest *request2 = [[ReseauxRequest alloc] init];
    request2.projectID = self.chantierSelectionne;
    Communicator *c = [[Communicator alloc] init];
    self.reseaux = (NSArray *)[c performRequest:request2];
    
    // affecter les réseaux au projet
    NSPredicate *chauffagePredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Reseau *r = (Reseau *)evaluatedObject;
        return r.type == ReseauTypeChauffage;
    }];
    NSPredicate *ecsPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Reseau *r = (Reseau *)evaluatedObject;
        return r.type == ReseauTypeECS;
    }];
    self.projet.reseauxChauffage = [self.reseaux filteredArrayUsingPredicate:chauffagePredicate];
    self.projet.reseauxECS = [self.reseaux filteredArrayUsingPredicate:ecsPredicate];
}

- (void)updateUI {
    
    // Address
    NSMutableArray *addressArray = [NSMutableArray array];
    NSMutableArray *cityArray = [NSMutableArray array];
    if (self.projet.numero) {
        [addressArray addObject:self.projet.numero];
    }
    if (self.projet.rue) {
        [addressArray addObject:self.projet.rue];
    }
    if (self.projet.code_postal) {
        [cityArray addObject:self.projet.code_postal];
    }
    if (self.projet.ville) {
        [cityArray addObject:self.projet.ville];
    }

    NSString *adresse1 = [addressArray componentsJoinedByString:@", "];
    NSString *adresse2 = [cityArray componentsJoinedByString:@", "];
    
    if ((adresse1.length == 0) && (adresse2.length == 0)) {
        self.addressCell.streetLabel.text = @"Aucune adresse renseignée";
        self.addressCell.cityLabel.text = @"";
    } else {
        self.addressCell.streetLabel.text = adresse1;
        self.addressCell.cityLabel.text = adresse2;
    }
    
    self.zoneCell.textLabel.text = [NSString stringWithFormat:@"%li zones", self.projet.zones.count];
    self.heatingCell.textLabel.text = [NSString stringWithFormat:@"%li réseaux de chauffage", self.projet.reseauxChauffage.count];
    
    self.commCell.textLabel.text = self.projet.note;
    
    // Date
    NSString *days = nil;
    NSString *date = nil;
    NSString *unite = nil;
    float number = [self.projet.numberOfTime floatValue];
    
    if ([self.projet.unitOfTime isEqual:@"Heure(s)"]) {
        if (number < 2) {
            unite = @"heure";
        } else {
            unite = @"heures";
        }
    }
    
    if ([self.projet.unitOfTime isEqual:@"Jour(s)"]) {
        if (number < 2) {
            unite = @"jour";
        } else {
            unite = @"jours";
        }
    }
    
    if ([self.projet.unitOfTime isEqual:@"Semaine(s)"]) {
        if (number < 2) {
            unite = @"semaine";
        } else {
            unite = @"semaines";
        }
    }
    
    self.duree = [self.projet.numberOfTime doubleValue];
    days = [NSString stringWithFormat:@"%.1f %@", self.duree, unite];
    
    if (self.projet.startDate) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.locale = [NSLocale localeWithLocaleIdentifier:@"FR_fr"];
        f.dateStyle = NSDateFormatterShortStyle;
        NSString *dateString = [f stringFromDate:self.projet.startDate];
        date = [NSString stringWithFormat:@"%@ à partir du %@", days, dateString];
    } else {
        date = days;
    }
    self.dateCell.textLabel.text = date;
    
    self.statusCell.textLabel.text = @"Visite technique faite";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"versCommentaireProjet"]) {
        commentaireViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
    if ([[segue identifier] isEqualToString:@"versCoordonneesChantier"]) {
        coordonneesChantierViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
    if ([[segue identifier] isEqualToString:@"versTechnicienProjet"]) {
        technicienProjetViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
   /*
    if ([[segue identifier] isEqualToString:@"versStatutProjet"]) {
        statutProjetViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    */
    
    if ([[segue identifier] isEqualToString:@"versPhotoProjet"]) {
        photosProjetViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
    if ([[segue identifier] isEqualToString:@"versTacheProjet"]) {
        tachesProjetViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
    if ([[segue identifier] isEqualToString:@"versDateProjet"]) {
        dateInstallationViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
    if ([[segue identifier] isEqualToString:@"versReseauxChauffage"]) {
        ReseauxChauffageTableViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }
    
}


@end


