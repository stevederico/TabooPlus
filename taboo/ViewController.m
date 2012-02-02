//
//  ViewController.m
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "LocalyticsSession.h"

@implementation ViewController
@synthesize gameButton;
@synthesize dataManager = _dataManager;
@synthesize contentArray;

#pragma mark - View lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
  
        // allocate a reachability object
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // set the blocks 
        reach.reachableBlock = ^(Reachability*reach)
        {
            NSLog(@"REACHABLE!");
            if (self.dataManager == nil) {
                self.dataManager = [[SDDataManager alloc] init];
                self.dataManager.delegate = self;
                [self.dataManager createRecordsWithParseClass:@"Word"];
                [self.dataManager resetUsed];
            }
            
            if (missedDownload == YES) {
                [self.dataManager createRecordsWithParseClass:@"Word"];
                [self.dataManager resetUsed];
            }
          
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
               NSLog(@"UNREACHABLE!");
            if (self.dataManager == nil) {
                self.dataManager = [[SDDataManager alloc] init];
                self.dataManager.delegate = self;
            }
            if ([self.dataManager isDBEmpty]) {
             
                dispatch_async(dispatch_get_main_queue(), ^{
                
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection" message:@"Please connect to the internet to download your cards" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    missedDownload = YES;
                
                
                });
                
                
               
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                self.gameButton.hidden = NO;
                  });
            }
            
       
            
            
        };
        
        // start the notifier which will cause the reachability object to retain itself!
        [reach startNotifier];
    }

    return self;

}


- (void) viewDidLoad{
    [super viewDidLoad];
     self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:54.0/255.0 green:64.0/255.0 blue:78.0/255.0 alpha:1.0];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sqr.png"]]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"End Game" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    self.title = @"What Word?";
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
      [self.dataManager resetUsed];
    


}

- (void)viewDidUnload {
    [self setGameButton:nil];
    [super viewDidUnload];
    self.contentArray = nil;
}




- (IBAction)startedTapped:(id)sender {
    
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"New Game"];
    
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


- (BOOL)checkForNetwork {
    
    //Check for Internet
    Reachability *wifiReach = [Reachability reachabilityWithHostname: @"www.apple.com"];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:{
            NSLog(@"Access Not Available");
            return NO;
            break;
        }
            
        case ReachableViaWWAN:{
            NSLog(@"Reachable WWAN");
            return YES;
            break;
        }
        case ReachableViaWiFi:{
            NSLog(@"Reachable WiFi");
            
            return YES;
            break;
        }
    }
    
    
    return YES;
    
}


- (void)dataReady{
    self.gameButton.hidden = NO;

}

@end
