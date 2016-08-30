//
//  photosDetailViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 17/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "photosDetailViewController2.h"

@interface photosDetailViewController ()

@end

@implementation photosDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    commentaire.delegate = self;
    self.commentairePhoto.delegate = self;
    
    if ([self.statut  isEqual: @"EXISTE"]) {
        
        self.choix.hidden = YES;
        
        [self importerDonnees];
        
        NSString *valeur = self.ligne;
        NSInteger num = [valeur intValue];
        NSDictionary *info = [listeProjets objectAtIndex:num];
        
        self.commentairePhoto.text = [info objectForKey:@"commentaire_photo"];
        NSString *adresse =[info objectForKey:@"url_photo"];
        adresse = [[adresse stringByReplacingOccurrencesOfString:@" " withString:@""]mutableCopy];
        NSURL *url = [NSURL URLWithString:adresse];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        photo.image = image;
        
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)thetextField {
    [commentaire resignFirstResponder];
    [self.commentairePhoto resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:0];
    
    if ([self.statut  isEqual: @"EXISTE"]) {
        NSLog(@"ACTION");
        [self envoiDonnees];
    }
    //[self envoiDonnees];

}



- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    photo.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
    
    /*
     UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
     UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
     [[Picker parentViewController] dismissModalViewControllerAnimated:YES];
     */
    
     boutonAjout.enabled = YES;
    
}


- (IBAction)choixPhoto:(id)sender {

    if (self.choix.selectedSegmentIndex == 0){
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        
    } else {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //A REMPLACER SI APPAREIL PHOTO
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        
        //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //[self presentModalViewController:picker animated:YES];
        
    }
    
}

- (void)importerDonnees
{
    
    NSString *chantier = self.chantierSelectionne;
    NSString *statut =@"OUVRE ";
   
    NSError *error;
    
    NSString *post = [NSString stringWithFormat:@"chantier=%@ &statut=%@", chantier, statut];
    //NSLog(post);
    NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
    //NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/photo_projet.php"]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.envertlaterre.fr/PHP/photo_projet.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataToSend];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];
    listeProjets = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

- (IBAction)ajouterPhoto:(id)sender {

    [self envoiPhoto];
    [self envoiDonnees];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)envoiPhoto
{
    // ENVOI PHOTO SUR SERVEUR
    
    NSData *imageData = UIImageJPEGRepresentation(photo.image, 0.4);
    
    //NSString *urlScript = @"http://localhost/import_photos.php";
    NSString *urlScript = @"http://www.envertlaterre.fr/PHP/import_photos.php";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlScript]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *reponseServeur = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    // RECUPERE ADRESSE PHOTO
    reponseServeur  = [[reponseServeur stringByReplacingOccurrencesOfString:@"\n" withString:@""]mutableCopy];
    self.photoStr = reponseServeur;
    
   // NSLog(reponseServeur);
    
    // FIN ENVOI PHOTO
    
}

- (void)envoiDonnees
{
    // ENVOI DONNEES MYSQL
    
    NSString *photo = self.photoStr;
    NSString *statut = self.statut;
    
    NSLog(statut);
    
    NSString *photoID = self.photoID;
    NSString *chantier = self.chantierSelectionne;
    NSString *commentaire =self.commentairePhoto.text;
    NSString *post = [NSString stringWithFormat:@"photo=%@&commentaire=%@&statut=%@&chantier=%@&photoID=%@ ", photo, commentaire, statut, chantier, photoID];
    
    NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
    //NSMutableURLRequest *request1 =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/photo_projet.php"]];
    NSMutableURLRequest *request1 =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.envertlaterre.fr/PHP/photo_projet.php"]];
    
    NSLog(photo);
    
    [request1 setHTTPMethod:@"POST"];
    [request1 setHTTPBody:dataToSend];
    NSData *data = [NSURLConnection sendSynchronousRequest:request1 returningResponse:Nil error:nil];
    
    // FIN ENVOI MYSQL
   //[self.navigationController popViewControllerAnimated:YES];

}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    photo.image = img;
}
 



@end
