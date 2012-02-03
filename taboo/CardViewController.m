//
//  CardViewController.m
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "LocalyticsSession.h"
#import "CardViewController.h"

@implementation CardViewController
@synthesize adj1Label;
@synthesize adj2Label;
@synthesize adj3Label;
@synthesize word;
@synthesize currentTeam;
@synthesize wordLabel;
@synthesize adj4;
@synthesize adj5;
@synthesize progressBar;
@synthesize words;
@synthesize currentIndex;
@synthesize timer,score;
@synthesize counter;




#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:229.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.adj1Label.textColor =  [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.adj2Label.textColor =  [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.adj3Label.textColor =  [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.adj4.textColor =  [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.adj5.textColor =  [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.wordLabel.textColor =  [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.progressBar.progressTintColor = [UIColor colorWithRed:54.0/255.0 green:64.0/255.0 blue:78.0/255.0 alpha:1.0];
 
    [self randomWord];
    self.counter = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skip)];
    self.navigationItem.rightBarButtonItem = skipButton;
    
    
}

- (void)setupDisplay{




}

- (void)viewDidUnload
{
    [self setAdj3Label:nil];
    [self setAdj2Label:nil];
    [self setAdj1Label:nil];
    [self setWord:nil];
    [self setWordLabel:nil];
    [self setAdj4:nil];
    [self setAdj5:nil];
    [self setProgressBar:nil];
    [self setTimer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)randomWord{

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:[SSManagedObject mainContext]]; 
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
    [request setEntity:entityDescription]; 
    [request setFetchLimit:10];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"used.boolValue == NO"];
    [request setPredicate:pred];
    
    NSArray *objects = [[SSManagedObject mainContext] executeFetchRequest:request error:nil];    
    if ([objects count]==0) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Out of Cards" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    NSUInteger rand = (arc4random() % [objects count]);
    NSLog(@"%d",rand);
    if (rand == [objects count]) {
        rand--;
    }
    
    self.word = [objects objectAtIndex:rand];


    [self loadLabels];

}


- (void)loadLabels{
    NSLog(@"%@",[self.word description]);
    self.wordLabel.text = self.word.name;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:adj1Label];
    [array addObject:adj2Label];
    [array addObject:adj3Label];
    [array addObject:adj4];
    [array addObject:adj5];
    int i = 0;
    NSArray *adjs = self.word.adjectives;
    for (UILabel *item in array) {
        item.text = [adjs objectAtIndex:i];
        i++;
    }

    self.title = [NSString stringWithFormat:@"Team %@",self.currentTeam];
  
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)nextTapped:(id)sender {
    

    
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithObjectsAndKeys:
    self.word.name, @"Word", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Guessed Correct" attributes:dictionary];
    
    
    self.score++;
    self.word.used = [NSNumber numberWithBool:YES];
    [self randomWord];
    
    [[SSManagedObject mainContext] saveWithoutMagic:nil];
}

- (void)skip {
    self.word.used = [NSNumber numberWithBool:YES];
    
    [[SSManagedObject mainContext] saveWithoutMagic:nil];
    
    [self randomWord];

}


- (void)playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimeUp" ofType:@"wav"];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        if (err != kAudioServicesNoError) {
            NSLog(@"Could not load %@, error code: %ld", url, err);
        } 
        
        AudioServicesPlaySystemSound(sound);
        
    }
}

- (void)roundOver{
    
    NSLog(@"ROUND OVER");
    
    [self playSound];

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber *team1 = [prefs objectForKey:@"Team1Score"];
    NSNumber *team2 = [prefs objectForKey:@"Team2Score"];

    score = 0;
    
    if (self.currentTeam ==[NSNumber numberWithInt:1]) {
        
        NSString *message = [NSString stringWithFormat:@"Team 1: %@",team1];
        
        NSString *current = [NSString stringWithFormat:@"Team 2: %@",team2];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:current delegate:self cancelButtonTitle:@"Next Team" otherButtonTitles: nil];
        [alert setDelegate:self];
        [alert show];
        
        self.currentTeam = [NSNumber numberWithInt:2];
        
    }else {
        self.currentTeam = [NSNumber numberWithInt:1];
        
        NSString *message = [NSString stringWithFormat:@"Team 2: %@",team2];
        
        NSString *current = [NSString stringWithFormat:@"Team 1: %@",team1];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:current delegate:self cancelButtonTitle:@"Next Team" otherButtonTitles: nil];
        [alert setDelegate:self];
        [alert show];
        
    }
    
    [self randomWord];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

        self.counter = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
        [self randomWord];
   
 
}

- (void)timerCallback{
    counter++;
    NSLog(@"%f",self.counter);
    float p = (float)self.counter/60;
    self.progressBar.progress = p;
    if (counter == 60) {
        [self roundOver];
        [self.timer invalidate];
         self.progressBar.progressTintColor = [UIColor colorWithRed:54.0/255.0 green:64.0/255.0 blue:78.0/255.0 alpha:1.0];
    }
    
    if (counter == 55) {
        self.progressBar.progressTintColor = [UIColor redColor];
    }


}

- (void)viewWillDisappear:(BOOL)animated {

    [self.timer invalidate];
    
    
}



@end
