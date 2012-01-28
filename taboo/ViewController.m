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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.title = @"Taboo";
    
    
    
    SDDataManager  *pdm = [[SDDataManager alloc] init];
    [pdm createRecordsWithPlistNamed:@"cards"];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.contentArray = nil;
}


- (IBAction)startedTapped:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:0] forKey:@"Team1Score"];
    [prefs setObject:[NSNumber numberWithInt:0] forKey:@"Team2Score"];
    [prefs synchronize];
    
    CardViewController *cvc = [[CardViewController alloc] init];
    cvc.wordDict = [self.contentArray objectAtIndex:0];
    cvc.words = self.contentArray;
    cvc.currentIndex = 0;
    cvc.currentTeam = [NSNumber numberWithInt:1];
    [self.navigationController pushViewController:cvc animated:YES];
    
}
@end
