//
//  CardViewController.h
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *adj1Label;
@property (strong, nonatomic) IBOutlet UILabel *adj2Label;
@property (strong, nonatomic) IBOutlet UILabel *adj3Label;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;

@property (nonatomic, strong) NSDictionary *wordDict;
@property (nonatomic, strong) NSNumber *currentTeam;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) int score;
- (IBAction)nextTapped:(id)sender;
- (void)loadLabels;
- (IBAction)skipTapped:(id)sender;
- (void)roundOver;
@end
