//
//  detailProjetBisViewController.h
//  Technicien
//
//  Created by Emmanuel Levasseur on 13/05/2015.
//  Copyright (c) 2015 En Vert La Terre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projet.h"
#import "Client.h"
#import "BadgeLabel.h"

@interface detailProjetBisViewController : UITableViewController<UITableViewDataSource, UITableViewDataSource>
{
    NSMutableArray *coordonnees;
    NSMutableArray *maListe;
    NSMutableArray *listeTemp;
}

@property (strong, nonatomic) Projet *projet;
@property (strong, nonatomic) Projet *coordonneesProjet;
@property (strong, nonatomic) Projet *projetDetail;
@property (strong, nonatomic) Client *client;
@property (strong, nonatomic) Client *coordonneesClient;

@property (strong, nonatomic) NSArray *tampon;
@property (strong, nonatomic) NSArray *reseaux;
@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) IBOutlet UILabel *nomClient;
@property (strong, nonatomic) IBOutlet UILabel *adresseClient;
@property (strong, nonatomic) IBOutlet UILabel *telephoneClient;
@property (weak, nonatomic) IBOutlet UILabel *reseauxChauffageLabel;
@property (weak, nonatomic) IBOutlet UILabel *reseauxECSLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentaireLabel;

//@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statutCommentaire;

@property (strong, nonatomic) id clientSelectionne;

@property (strong, nonatomic) NSString *nom;
@property (strong, nonatomic) NSString *prenom;

@property (weak, nonatomic) IBOutlet BadgeLabel *badgeChauffage;
@property (weak, nonatomic) IBOutlet BadgeLabel *badgeECS;
@property (weak, nonatomic) IBOutlet BadgeLabel *badgePhotos;

- (IBAction)boutonChauffage:(id)sender;
- (IBAction)boutonECS:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UILabel *labelTest;

@end
