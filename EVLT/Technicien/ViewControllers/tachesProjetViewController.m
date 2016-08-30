//
//  tachesProjetViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 10/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "tachesProjetViewController.h"

@interface tachesProjetViewController ()

@end

@implementation tachesProjetViewController

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
    [super viewDidLoad];
    
    maListe = [[NSMutableArray alloc] init];
    [maListe addObject:@"Minutes"];
    [maListe addObject:@"Heures"];
    [maListe addObject:@"Jours"];
    [maListe addObject:@"Semaines"];
    
    //TEST RECEPTION ID CHANTIER
    //NSLog(self.chantierSelectionne;);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [maListe count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [maListe objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)importerDonnees
{
    NSError *error;
    NSMutableString * strlURL = [[NSMutableString alloc] initWithFormat:FindURL];
    
    NSURL *url = [NSURL URLWithString:strlURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    listeClients = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}
 */

- (void) viewDidAppear:(BOOL)animated
{
    //[self importerDonnees];
    //[self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self exporterDonnees];
    //[super viewWillDisappear:0];
    
}

- (void)importerDonnees
{
    
    NSString *chantier = self.chantierSelectionne;
    NSString *statut =@"OUVRE";
    NSError *error;
    NSString *post = [NSString stringWithFormat:@"chantier=%@ &statut=%@", chantier, statut];
    //NSLog(post);
    NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
    //NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/taches_chantier.php"]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.envertlaterre.fr/PHP/taches_chantier.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataToSend];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];
    commentaire = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [commentaire objectAtIndex:0];
    self.tempsText.text = [info objectForKey:@"temps_total"];
    
    NSString *unite =[info objectForKey:@"unite_temps"];
    NSInteger ligne;
    ligne = 0;
    
    if ([unite  isEqual:@"minutes"]) {
        ligne = 0;
    }
    if ([unite  isEqual:@"heures"]) {
        ligne = 1;
    }
    if ([unite  isEqual:@"jours"]) {
        ligne = 2;
    }
    if ([unite  isEqual:@"semaines"]) {
        ligne = 3;
    }
    
    [self.uniteTemps selectRow:ligne inComponent:0 animated:NO];
    
}

- (void)exporterDonnees
{
    NSInteger *typeLigne = [self.uniteTemps selectedRowInComponent:0];
    NSString *partie1 =[maListe objectAtIndex:typeLigne];
    
    NSString *chantier = self.chantierSelectionne;
    NSString *temps =self.tempsText.text;
    NSString * unite = [NSString stringWithFormat:@"%@", partie1];
    
    NSString *post = [NSString stringWithFormat:@"chantier=%@&temps=%@&unite=%@", chantier, temps, unite];
    
    NSLog(post);
    
    /*
    NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/taches_chantier.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataToSend];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];
     */
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 0) {
       return 1;
    }
    /*
    if (section == 1) {
        return 1;
    }
    */
    return YES;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (IBAction)ajoutLigne:(id)sender {
}
@end
