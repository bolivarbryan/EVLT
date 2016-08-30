//
//  ReseauChauffageEditionViewController.m
//  Commercial
//
//  Created by Benjamin Petit on 17/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//
/*
#import "ReseauChauffageEditionViewController.h"
#import "EditableTableViewCell.h"
#import "ReseauxRequest.h"
#import "Communicator.h"
#import "Projet.h"

@interface ReseauChauffageEditionViewController() <UITextFieldDelegate>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL exists;
@property (assign, nonatomic) BOOL emetteur;
@property (assign, nonatomic) ReseauMaterial materiau;
@property (strong, nonatomic) NSString *diameter;

@property (strong, nonatomic) EditableTableViewCell *diameterCell;
@property (strong, nonatomic) EditableTableViewCell *nomCell;

@end

@implementation ReseauChauffageEditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.reseau.statut);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(validate:)];
    
    self.exists = self.reseau.existing;
    self.diameter = self.reseau.diameter;
    self.name = self.reseau.name;
    self.emetteur = self.reseau.radiateurs;
    self.materiau = self.reseau.material;
}

#pragma mark - UITableViewControllerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 2;
            break;
        case 2:
            count = 2;
            break;
        case 3:
            count = 3;
            break;
        case 4:
            count = 1;
            break;
    }
    return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 30.0f)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.diameterCell.textField resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            cell = [self tableView:tableView nomCellForRowAtIndexPath:indexPath];
            break;
            case 1:
            cell = [self tableView:tableView creationCellForRowAtIndexPath:indexPath];
            break;
            case 2:
            cell = [self tableView:tableView emetteurCellForRowAtIndexPath:indexPath];
            break;
            case 3:
            cell = [self tableView:tableView materiauCellForRowAtIndexPath:indexPath];
            break;
            case 4:
            cell = [self tableView:tableView diameterCellForRowAtIndexPath:indexPath];
            default:
            break;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView nomCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"diameterCell"];
    cell.titleLabel.text = @"Nom";
    cell.textField.placeholder = @"Réseau";
    cell.textField.keyboardType = UIKeyboardTypeAlphabet;
    cell.textField.delegate = self;
    cell.textField.text = self.name;
    self.nomCell = cell;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView creationCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choiceCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Existant";
        cell.accessoryType = self.exists ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = @"Non existant";
        cell.accessoryType = self.exists ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emetteurCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choiceCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Radiateurs";
        cell.accessoryType = self.emetteur ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = @"Plancher chauffant";
        cell.accessoryType = self.emetteur ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView materiauCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choiceCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Cuivre";
        cell.accessoryType = (self.materiau == ReseauMaterialCuivre) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"PER";
        cell.accessoryType = (self.materiau == ReseauMaterialPER) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = @"Acier";
        cell.accessoryType = (self.materiau == ReseauMaterialAcier) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView diameterCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"diameterCell"];
    cell.titleLabel.text = @"Diamètre";
    cell.textField.placeholder = @"28";
    cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cell.textField.delegate = self;
    cell.textField.text = self.diameter;
    self.diameterCell = cell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            self.exists = (indexPath.row == 0);
            break;
        case 2:
            self.emetteur = (indexPath.row == 0);
            break;
        case 3:
            self.materiau = (int)indexPath.row;
            break;
        default:
            break;
    }
    
    NSLog(@"%@ %hhd  %hhd  %d %@", self.name, self.exists, self.emetteur, self.materiau, self.diameter);
    
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.diameter = self.diameterCell.textField.text;
    self.name = self.nomCell.textField.text;
}

#pragma mark - UI Actions

- (void)validate:(id)sender {
    [self.diameterCell.textField resignFirstResponder];
    self.reseau.existing = self.exists;
    self.reseau.diameter = self.diameter;
    self.reseau.name = self.name;
    
    NSString * step1 = self.exists ? @"Existant" : @"A creer";
    NSString * step2 = self.emetteur ? @"Plancher chauffant" : @"Radiateurs";
    
    NSLog(@"diametre : %@", self.diameterCell.textField.text);
    NSLog(@"%@", self.projet.identifier);
   
    ReseauxRequest *request = [[ReseauxRequest alloc] init];
    request.projectID = self.projet.identifier;
    request.action = self.reseau.statut;
    request.reseauID = self.reseau.identifier;
    request.type = @"chauffage";
    request.nom = self.reseau.name;
    request.existe = step1;
    request.radiateur = step2;
    request.cuivre = [NSString stringWithFormat:@"%i", self.materiau];
    request.diametre = self.reseau.diameter;
    Communicator *comm = [[Communicator alloc] init];
    [comm performRequest:request];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end*/
