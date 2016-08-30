//
//  dateInstallationViewController.m
//  Commercial
//
//  Created by Emmanuel Levasseur on 03/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "dateInstallationViewController2.h"
#import "DateRequest2.h"
#import "Communicator2.h"
#import "TimeConverter2.h"

@interface dateInstallationViewController ()

{
    NSArray *_pickerData;
}

@end

@implementation dateInstallationViewController

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
    
    // Initialize Data
    _pickerData = @[@"Heure(s)", @"Jour(s)", @"Semaine(s)"];
    
    // Connect data
    self.uniteTemps.dataSource = self;
    self.uniteTemps.delegate = self;

   // _dateInstallation = self.projet.startDate;
    self.dateInstallation.date = self.projet.startDate;
    
    NSString *duree = [NSString stringWithFormat:@"%@", self.projet.numberOfTime];
    
    self.dureeLabel.text = duree;
    
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

/*
- (IBAction)dateChange:(id)sender {
    
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSDate *pickerDate = [_dateInstallation date];
    NSDateFormatter *formatageDate = [[NSDateFormatter alloc] init];
    [formatageDate setDateFormat:@"yyyy-MM-dd"];
    NSString *dateFormatee = [formatageDate stringFromDate:pickerDate];
    
    self.dateChoisie = dateFormatee;
    
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    float duree = [self.dureeLabel.text floatValue];
    self.litteralDureeLabel.text = [TimeConverter stringForNumberOfDays:duree];
}

- (IBAction)boutonValider:(id)sender {
    NSLog(@"OKOK");
    
    //   NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    NSDate *pickerDate = [_dateInstallation date];
    NSDateFormatter *formatageDate = [[NSDateFormatter alloc] init];
    [formatageDate setDateFormat:@"yyyy-MM-dd"];
    NSString *dateFormatee = [formatageDate stringFromDate:pickerDate];
    
    DateRequest *request = [[DateRequest alloc] init];
    request.projectID = self.projet.identifier;
    request.statut = @"FERME";
    request.date = dateFormatee;
    request.duree = self.dureeLabel.text;
    Communicator *comm = [[Communicator alloc] init];
    [comm performRequest:request];
    self.projet.startDate = pickerDate;
    self.projet.numberOfTime = @"10";
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
