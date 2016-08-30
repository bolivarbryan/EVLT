//
//  coordonneesChantierViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 04/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "coordonneesChantierViewController.h"
#import "CoordonneesProjectRequest.h"
#import "Communicator.h"

@interface coordonneesChantierViewController ()

@end

@implementation coordonneesChantierViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.numeroText.text = self.projet.numero;
    self.rueText.text = self.projet.rue;
    self.codePostalText.text = self.projet.code_postal;
    self.villeText.text = self.projet.ville;

}

- (IBAction)boutonValider:(id)sender {
    
    CoordonneesProjectRequest *request = [[CoordonneesProjectRequest alloc] init];
    request.projectID = self.projet.identifier;
    request.statut = @"FERME";
    request.numero = self.numeroText.text;
    request.rue = self.rueText.text;
    request.code_postal = self.codePostalText.text;
    request.ville = self.villeText.text;
    Communicator *comm = [[Communicator alloc] init];
    self.projet = (Projet *)[comm performRequest:request];
    
    self.projet.numero = self.numeroText.text;
    self.projet.rue = self.rueText.text;
    self.projet.code_postal = self.codePostalText.text;
    self.projet.ville = self.villeText.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
