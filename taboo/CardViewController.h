//
//  CardViewController.h
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "Word.h"
#import <UIKit/UIKit.h>

@interface CardViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *adj1Label;
@property (strong, nonatomic) IBOutlet UILabel *adj2Label;
@property (strong, nonatomic) IBOutlet UILabel *adj3Label;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UILabel *adj4;
@property (strong, nonatomic) IBOutlet UILabel *adj5;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic, strong) Word *word;
@property (nonatomic, strong) NSNumber *currentTeam;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) int score;
@property (nonatomic,assign) float counter;


- (IBAction)nextTapped:(id)sender;
- (void)loadLabels;
- (void)skip;
- (void)roundOver;
- (void)randomWord;
- (void)timerCallback;

@end
