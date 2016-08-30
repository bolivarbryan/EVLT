//
//  ProggramationViewController.m
//  EVLT
//
//  Created by bolivarbryan on 26/08/16.
//  Copyright © 2016 EVLT. All rights reserved.
//

#import "ProggramationViewController.h"

@interface ProggramationViewController ()

@end

@implementation ProggramationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title  = @"Administratif";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
