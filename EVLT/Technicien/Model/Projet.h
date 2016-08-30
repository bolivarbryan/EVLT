//
//  Projet.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 28/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    ProjetNatureInstallation = 0,
    ProjetNatureDepannage,
    ProjetNatureEntretien,
    ProjetNatureOther
} ProjetNature;

typedef enum {
    ProjetProduitPoele = 0,
    ProjetProduitChaudiere,
    ProjetProduitPompeChaleur,
    ProjetProduitBallon,
    ProjetProduitOther
} ProjetProduit;

typedef enum {
    ProjetEnergieGranules = 0,
    ProjetEnergieBoisBuches,
    ProjetEnergieGaz,
    ProjetEnergieFioul,
    ProjetEnergieOther
} ProjetEnergie;

typedef enum {
    ProjectStatusVisiteDone = 0,
    ProjectStatusSent,
    ProjectStatusAccepted,
    ProjectStatusInactif,
    ProjectStatusCount
} ProjectStatus;

@interface Projet : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *type;

@property (assign, nonatomic) ProjectStatus status;
@property (assign, nonatomic) ProjetNature nature;
@property (assign, nonatomic) ProjetProduit produit;
@property (assign, nonatomic) ProjetEnergie energie;

@property (strong, nonatomic) NSString *otherNature;

@property (strong, nonatomic) NSString *numero;
@property (strong, nonatomic) NSString *rue;
@property (strong, nonatomic) NSString *code_postal;
@property (strong, nonatomic) NSString *ville;
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;

@property (strong, nonatomic) NSString *prix;
@property (strong, nonatomic) NSString *tva;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSString *numberOfTime;
@property (strong, nonatomic) NSString *unitOfTime;

@property (strong, nonatomic) NSArray *zones;
@property (strong, nonatomic) NSArray *reseauxChauffage;
@property (strong, nonatomic) NSArray *reseauxECS;

@property (strong, nonatomic) NSArray *technicians;

@property (strong, nonatomic) NSString *gaetan;
@property (strong, nonatomic) NSString *fred;
@property (strong, nonatomic) NSString *denis;
@property (strong, nonatomic) NSString *vincent;

@property (strong, nonatomic) NSString *note;

@property (strong, nonatomic) NSString *statut;
@property (strong, nonatomic) NSString *statutComplet;

@property (assign, nonatomic) CLLocationCoordinate2D coords;

+ (NSString *)nameForStatus:(ProjectStatus)status;
+ (NSString *)technicalNameForStatus:(ProjectStatus)status;
+ (ProjectStatus)statusForName:(NSString *)name;

- (NSString *)addressString;

//+ (NSString *)nameForStatus:(int)status;

@end
