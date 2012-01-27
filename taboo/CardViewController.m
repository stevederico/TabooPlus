//
//  CardViewController.m
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "CardViewController.h"

@implementation CardViewController
@synthesize adj1Label;
@synthesize adj2Label;
@synthesize adj3Label;
@synthesize wordDict;
@synthesize currentTeam;
@synthesize wordLabel;
@synthesize words;
@synthesize currentIndex;
@synthesize timer,score;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadLabels];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(roundOver) userInfo:nil repeats:NO];
    
}


- (void)loadLabels{

    self.wordLabel.text = [self.wordDict valueForKey:@"Word"];
    self.adj1Label.text = [self.wordDict valueForKey:@"Adjective 1"];
    self.adj2Label.text = [self.wordDict valueForKey:@"Adjective 2"];
    self.adj3Label.text = [self.wordDict valueForKey:@"Adjective 3"];
    self.title = [NSString stringWithFormat:@"Team %@",self.currentTeam];
  
}



- (void)viewDidUnload
{
    [self setAdj3Label:nil];
    [self setAdj2Label:nil];
    [self setAdj1Label:nil];
    [self setWordDict:nil];
    [self setWordLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)nextTapped:(id)sender {
    
    self.score++;
    currentIndex++;
 
    if (currentIndex == [self.words count]) {
        currentIndex = 0;
        self.wordDict = [self.words objectAtIndex:0];
        [self loadLabels];
        return;
    }
    self.wordDict = [self.words objectAtIndex:currentIndex];
    
 
    [self loadLabels];
    

}

- (IBAction)skipTapped:(id)sender {
    
    currentIndex++;
    
    if (currentIndex == [self.words count]) {
        currentIndex = 0;
        self.wordDict = [self.words objectAtIndex:0];
        [self loadLabels];
        return;
    }
    self.wordDict = [self.words objectAtIndex:currentIndex];
    
    
    [self loadLabels];
}

- (void)roundOver{

    NSLog(@"ROUND OVER");
    
    NSString *message = [NSString stringWithFormat:@"Team %@ Score: %d",self.currentTeam,score];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Round Over" message:message delegate:self cancelButtonTitle:@"Game Over" otherButtonTitles:@"Next Team", nil];
    [alert setDelegate:self];
    [alert show];
    
    
    if (self.currentTeam ==[NSNumber numberWithInt:1]) {
        self.currentTeam = [NSNumber numberWithInt:2];
    }else {
      self.currentTeam = [NSNumber numberWithInt:1];
    
    }
    if (currentIndex == [self.words count]) {
        currentIndex = 0;
        self.wordDict = [self.words objectAtIndex:currentIndex];
        [self loadLabels];
        return;
    }
    
    if (currentTeam == [NSNumber numberWithInt:1]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int balance = [[prefs valueForKey:@"Team1Score"] intValue];
        int newScore = balance +score;
        [prefs setObject:[NSNumber numberWithInt:newScore] forKey:@"Team1Score"];
        NSLog(@"Score Updated to %@",[NSNumber numberWithInt:newScore]);
        [prefs synchronize];
    }
    
    if (currentTeam == [NSNumber numberWithInt:2]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int balance = [[prefs valueForKey:@"Team2Score"] intValue];
        int newScore = balance +score;
        [prefs setObject:[NSNumber numberWithInt:newScore] forKey:@"Team2Score"];
        NSLog(@"Score Updated to %@",[NSNumber numberWithInt:newScore]);
        [prefs synchronize];
    }
    
    score = 0;
    
    self.wordDict = [self.words objectAtIndex:currentIndex++];

    
    



}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex >0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(roundOver) userInfo:nil repeats:NO];
           [self loadLabels];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    
    }
 
    
    

}

@end
