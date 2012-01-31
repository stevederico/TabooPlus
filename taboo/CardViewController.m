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
   
    [self randomWord];
     self.counter = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skip)];
    self.navigationItem.rightBarButtonItem = skipButton;
    
    
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
    
    [self randomWord];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex >0) {
        self.counter = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
        [self randomWord];
    }else{
        [self.timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    
    }
 
}

- (void)timerCallback{
    counter++;
    NSLog(@"%f",self.counter);
    float p = (float)self.counter/30;
    self.progressBar.progress = p;
    if (counter == 30) {
        [self roundOver];
        [self.timer invalidate];
    }


}

@end
