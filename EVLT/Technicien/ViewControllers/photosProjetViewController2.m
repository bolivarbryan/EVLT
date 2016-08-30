//
//  photosProjetViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 10/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "photosProjetViewController2.h"
#import "photosDetailViewController2.h"
#import "Photo2.h"
// #import "DeleteRequest2.h"
#import "Communicator2.h"

@interface photosProjetViewController ()

@end

@implementation photosProjetViewController
@synthesize objManager;

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
    
    //  [super viewDidLoad];
    //   [self importerDonnees];
    
    self.title = @"Photos";
    
    objManager = [DropboxManager dropBoxManager];
    objManager.apiCallDelegate =self;
    [objManager initDropbox];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    // [self testDropBox];
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self importerDonnees];
    [self.tableView reloadData];
    [super viewWillAppear:0];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.restClient.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// DEBUT DROPBOX
// DEBUT DROPBOX
// DEBUT DROPBOX
// DEBUT DROPBOX

- (void)testDropBox
{
    [[self restClient] loadMetadata:@"/"];
    
    NSString *fileName = self.urlTemp;
    NSString *path2 = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    self.urlPhoto = path2;
    //   NSLog(@" URL : %@", self.urlPhoto);
    [[self restClient] loadFile:fileName intoPath:path2];
    
    UIImage* image = [UIImage imageWithContentsOfFile:self.urlPhoto];
    self.TestImage = image;
    
}

/*
 - (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
 if (metadata.isDirectory) {
 NSLog(@"Folder '%@' contains:", metadata.path);
 for (DBMetadata *file in metadata.contents) {
 NSLog(@"\t%@", file.filename);
 }
 }
 }
 */

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    // NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

- (void)finishedDownloadFile
{
    //   NSLog(@"YOUPI");
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    //  NSLog(@"File uploaded successfully to path: %@", metadata.path);
    //  self.photoURL = metadata.path;
    //  NSLog(@"URL : %@", self.photoURL);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)finishedUploadFile
{
    NSLog(@"Uploaded successfully.");
}

- (void)failedToUploadFile:(NSString*)withMessage
{
    NSLog(@"Failed to upload error is %@",withMessage);
}


// FIN DROPBOX
// FIN DROPBOX
// FIN DROPBOX
// FIN DROPBOX

- (void)importerDonnees
{
    NSError *error;
    
    //criteres
    NSString *chantier =self.chantierSelectionne;
    NSString *statut = @"OUVRE ";
    
    NSString *post = [NSString stringWithFormat:@"chantier=%@ &statut=%@", chantier, statut];
    NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.envertlaterre.fr/PHP/photo_projet.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataToSend];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];
    listeProjets = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", photo.commentaire];
    
    self.urlTemp = [NSString stringWithFormat:@"%@", photo.url];
    
    [self testDropBox];
    
    photo.image =self.TestImage;
    cell.imageView.image = photo.image;
    
    return cell;
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // peut rester vide
}

/*

 CODE POUR EFFACER PHOTO
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // SUPPRIMER LIGNE
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Photo *photo = [self.photos objectAtIndex:indexPath.row];
        NSString *identifiant = photo.identifier;
        
        [self.photos removeObjectAtIndex:indexPath.row];
        
        DeleteRequest *request = [[DeleteRequest alloc] init];
        request.requete = [NSString stringWithFormat:@"DELETE FROM `envertlaevlt`.`photos_chantier` WHERE `photos_chantier`.`photos_chantier_id` = %@", identifiant];
        Communicator *comm = [[Communicator alloc] init];
        [comm performRequest:request];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self importerDonnees];
        [self.tableView reloadData];
        
    }
}
*/

/*
 
// NAVIGATION 
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"versDetailPhoto"]) {
        photosDetailViewController *dvc = [segue destinationViewController];
        dvc.statut = @"CREATION";
        dvc.projet = self.projet;
        dvc.chantierSelectionne = self.chantierSelectionne;
    }
    
    if ([[segue identifier] isEqualToString:@"versPhotoExistante"]) {
        
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        photosDetailViewController *dvc = [segue destinationViewController];
        dvc.statut = @"EXISTE";
        dvc.projet = self.projet;
        dvc.chantierSelectionne = self.chantierSelectionne;
        
        Photo *EnvoiPhoto = [self.photos objectAtIndex:selectedIndex];
        dvc.photoActive = EnvoiPhoto;
        
    }
    
}
 */

@end
