//
//  commentaireViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "commentaireViewController2.h"
#import "CommentaireRequest2.h"
#import "Communicator2.h"

@interface commentaireViewController ()

@end

@implementation commentaireViewController

//@synthesize commentaireText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbar.hidden = YES;
    
    self.commentaireText.text = self.projet.note;
}

- (IBAction)boutonValider:(id)sender {
    CommentaireRequest *request = [[CommentaireRequest alloc] init];
    request.projectID = self.projet.identifier;
    request.statut = @"FERME";
    request.commentaire = self.commentaireText.text;
    Communicator *comm = [[Communicator alloc] init];
    [comm performRequest:request];
    self.projet.note = self.commentaireText.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
