//  technicienViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 05/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "technicienprojetViewController2.h"

@interface technicienProjetViewController ()

@end

@implementation technicienProjetViewController

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
    
    [self importerDonnees];
    [super viewDidLoad];
    
    
    // Test reception id chantier
    //    NSLog(self.chantierSelectionne);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self exporterDonnees];
    [super viewWillDisappear:0];
    
}



- (void)importerDonnees
{

    
     NSString *chantier = self.chantierSelectionne;
     NSString *statut =@"OUVRE";
     NSError *error;
     NSString *post = [NSString stringWithFormat:@"chantier=%@ &statut=%@", chantier, statut];
     //NSLog(post);
     NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
     //NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/technicien_projet.php"]];
     NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.envertlaterre.fr/PHP/technicien_projet.php"]];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:dataToSend];
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];
     commentaire = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      NSDictionary *info = [commentaire objectAtIndex:0];
    
    self.statutGaetan =[info objectForKey:@"gaetan"];
    self.statutFred =[info objectForKey:@"fred"];
    self.statutDenis =[info objectForKey:@"denis"];
    self.statutVincent =[info objectForKey:@"vincent"];
    
 

    if ([[info objectForKey:@"gaetan"] isEqual:@"oui "]) {
        gaetanSwitch.on =YES;
    }
    
    if ([[info objectForKey:@"fred"] isEqual:@"oui "]) {
        fredSwitch.on =YES;
    }
    
    if ([[info objectForKey:@"denis"] isEqual:@"oui "]) {
        denisSwitch.on =YES;
    }
    
    if ([[info objectForKey:@"vincent"] isEqual:@"oui"]) {
        vincentSwitch.on =YES;
    }
}


 - (void)exporterDonnees
 {
 NSString *chantier = self.chantierSelectionne;
     
 NSString *gaetan =self.statutGaetan;
 NSString *fred =self.statutFred;
 NSString *denis =self.statutDenis;
 NSString *vincent =self.statutVincent;

 NSString *post = [NSString stringWithFormat:@"chantier=%@&gaetan=%@&fred=%@&denis=%@&vincent=%@", chantier, gaetan, fred, denis, vincent];
 NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
 //NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/technicien_projet.php"]];
 NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.envertlaterre.fr/PHP/technicien_projet.php"]];
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody:dataToSend];
 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];

 }

 
 - (IBAction)gaetanSwitch:(id)sender{
 if([sender isOn]){
self.statutGaetan = @"oui";
 }else{
self.statutGaetan = @"non";
 }
 }

- (IBAction)fredSwitch:(id)sender{
    if([sender isOn]){
        self.statutFred = @"oui";
    }else{
        self.statutFred = @"non";
    }
}

- (IBAction)denisSwitch:(id)sender{
    if([sender isOn]){
        self.statutDenis = @"oui";
    }else{
        self.statutDenis = @"non";
    }
}

- (IBAction)vincentSwitch:(id)sender{
    if([sender isOn]){
        self.statutVincent = @"oui";
    }else{
        self.statutVincent = @"non";
    }
}

 

@end
