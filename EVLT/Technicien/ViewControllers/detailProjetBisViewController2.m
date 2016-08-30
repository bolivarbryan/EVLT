//
//  detailProjetBisViewController.m
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import "detailProjetBisViewController2.h"
#import "ProjectDetailRequest2.h"
#import "commentaireViewController2.h"
#import "CoordonneesProjectRequest2.h"
#import "CoordonneesClientRequest2.h"
#import "ReseauxRequest2.h"
#import "PhotosRequest2.h"
#import "ReseauxChauffageTableViewController2.h"
#import "ReseauxECSTableViewController2.h"
#import "photosProjetViewController2.h"
#import "Communicator2.h"
#import "Projet2.h"
#import "Client2.h"
#import "Reseau2.h"
#import "Photo2.h"

@interface detailProjetBisViewController ()

@property (strong, nonatomic) NSArray *coordonneesBis;

@end

@implementation detailProjetBisViewController

@synthesize badgeChauffage;
@synthesize badgeECS;
@synthesize badgePhotos;


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [badgeChauffage setStyle:BadgeLabelStyleAppIcon];
    [badgeECS setStyle:BadgeLabelStyleAppIcon];
    [badgePhotos setStyle:BadgeLabelStyleAppIcon];
    
    [self communication];
    [self attribution];
    
    self.mySlider.minimumValue = 0;
    self.mySlider.maximumValue = 5;
    
}

- (void)communication {
    ProjectDetailRequest *request = [[ProjectDetailRequest alloc] init];
    request.projectID = self.projet.identifier;
    Communicator *comm = [[Communicator alloc] init];
    self.projetDetail = (Projet *)[comm performRequest:request];
    
    CoordonneesProjectRequest *request2 = [[CoordonneesProjectRequest alloc] init];
    request2.projectID = self.projet.identifier;
    request2.statut = @"OUVRE";
    Communicator *comm2 = [[Communicator alloc] init];
    self.coordonneesProjet = (Projet *) [comm2 performRequest:request2];
    
    CoordonneesClientRequest *request3 = [[CoordonneesClientRequest alloc] init];
    request3.clientID = self.client.identifier;
    Communicator *comm3 = [[Communicator alloc] init];
    self.coordonneesClient = (Client *) [comm3 performRequest:request3];
    
    ReseauxRequest *request4 = [[ReseauxRequest alloc] init];
    request4.projectID = self.projet.identifier;
    request4.action = @"OUVRE";
    Communicator *c4 = [[Communicator alloc] init];
    self.reseaux = (NSArray *)[c4 performRequest:request4];
    
    PhotosRequest *request5 = [[PhotosRequest alloc] init];
    request5.projectID = self.projet.identifier;
    request5.statut = @"OUVRE";
    Communicator *c5 = [[Communicator alloc] init];
    self.photos = (NSArray *)[c5 performRequest:request5];

    NSMutableSet *coord = [NSMutableSet set];
    Client *clientbis = [self clientWithId2:self.client.identifier];
    [coord addObject:clientbis];
    listeTemp = [[coord allObjects] mutableCopy];
    Client *c = [listeTemp objectAtIndex:0];
    
    self.projet.numero = self.coordonneesProjet.numero;
    self.projet.rue = self.coordonneesProjet.rue;
    self.projet.code_postal = self.coordonneesProjet.code_postal;
    self.projet.ville = self.coordonneesProjet.ville;
    self.projet.note = self.projetDetail.note;
    
    self.client.mobilePhone = c.mobilePhone;
    self.client.phone = c.phone;
    
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

- (void)attribution {
    self.nomClient.text = [NSString stringWithFormat:@"%@ %@", self.client.firstName, self.client.lastName];
    self.adresseClient.text = [NSString stringWithFormat:@"%@, %@. %@ %@", self.projet.numero, self.projet.rue, self.projet.code_postal, self.projet.ville];
    
    NSString *statutFixe = self.client.phone;
    NSString *statutPortable = self.client.mobilePhone;
    
    if ([self.client.phone isEqual:@"Tel. Fixe"]) {
        statutFixe = @"inconnu";
    }
    if ([self.client.mobilePhone isEqual:@"Tel. Portable"]) {
        statutPortable = @"inconnu";
    }
    
    self.telephoneClient.text = [NSString stringWithFormat:@"FIXE : %@ / PORTABLE : %@", statutFixe, statutPortable];
    
    /*
    NSString *nbReseauxChauffage;
    nbReseauxChauffage = @"réseau";
    if (self.projet.reseauxChauffage.count > 1) {
        nbReseauxChauffage =@"réseaux";
    }
    self.reseauxChauffageLabel.text = [NSString stringWithFormat:@"%li %@ de chauffage", (unsigned long)self.projet.reseauxChauffage.count, nbReseauxChauffage];
    */
    badgeChauffage.text = [NSString stringWithFormat:@"%li", (unsigned long)self.projet.reseauxChauffage.count];
    badgeECS.text = [NSString stringWithFormat:@"%li", (unsigned long)self.projet.reseauxECS.count];
    badgePhotos.text = [NSString stringWithFormat:@"%i", self.photos.count];

}

- (Client *)clientWithId2:(NSString *)identifier {
    for (Client *c in self.coordonneesClient) {
        if ([c.identifier isEqualToString:identifier]) {
            return c;
        }
    }
    return nil;
}

#pragma navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"versCommentaireProjet"]) {
        commentaireViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
    }

 /*
    if ([[segue identifier] isEqualToString:@"versPhotoProjet"]) {
        photosProjetViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
        dvc.photos = self.photos;
    }
  */

    
    if ([[segue identifier] isEqualToString:@"versReseauxChauffage"]) {
        ReseauxChauffageTableViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
        dvc.reseaux = self.projet.reseauxChauffage;
    }
    
    if ([[segue identifier] isEqualToString:@"versReseauxECS"]) {
        ReseauxECSTableViewController *dvc = [segue destinationViewController];
        dvc.projet = self.projet;
        dvc.reseaux = self.projet.reseauxECS;
    }
 

    
}

#pragma actions

- (IBAction)boutonChauffage:(id)sender {
}

- (IBAction)boutonECS:(id)sender {
}

- (IBAction)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    slider.value = val;

    NSString *valeurStatut = @"";
    switch (val) {
        case 0:
        {
            valeurStatut = @"0 %";
        }
            break;
        case 1:
        {
            valeurStatut = @"20 %";
        }
            break;
        case 2:
        {
            valeurStatut = @"40 %";
        }
            break;
        case 3:
        {
            valeurStatut = @"60 %";
        }
            break;
        case 4:
        {
            valeurStatut = @"80 %";
        }
            break;
        case 5:
        {
            valeurStatut = @"100 %";
        }
            break;
        default:
            break;

    }
    
    self.labelTest.text = valeurStatut;
    
}

@end
