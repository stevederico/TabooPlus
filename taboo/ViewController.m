//
//  ViewController.m
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "SDDataManager.h"
#import "ViewController.h"

@implementation ViewController
@synthesize contentArray;

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.

    self.title = @"What Word?";
    
    SDDataManager *pdm = [[SDDataManager alloc] init];
    [pdm createRecordsWithParseClass:@"Word"];
    [pdm resetUsed];
    
    
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"End Game" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;


}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.contentArray = nil;
}


- (IBAction)startedTapped:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:0] forKey:@"Team1Score"];
    [prefs setObject:[NSNumber numberWithInt:0] forKey:@"Team2Score"];
    [prefs synchronize];
    
    CardViewController *cvc = [[CardViewController alloc] init];
    cvc.words = self.contentArray;
    cvc.currentIndex = 0;
    cvc.title = @"Team 1";
    cvc.currentTeam = [NSNumber numberWithInt:1];
    [self.navigationController pushViewController:cvc animated:YES];
    
}
@end
