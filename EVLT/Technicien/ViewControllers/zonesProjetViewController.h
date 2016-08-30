//
//  zonesProjetViewController.h
//  Commercial
//
//  Created by Emmanuel Levasseur on 24/02/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zonesProjetViewController : UITableViewController
{
 int nbZones;
}

- (IBAction)nombreChauffage:(id)sender;
- (IBAction)nombreECS:(id)sender;

- (IBAction)ajoutZone:(id)sender;


@end
