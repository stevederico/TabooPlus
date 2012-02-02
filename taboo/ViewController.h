//
//  ViewController.h
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "SDDataManager.h"
 
@interface ViewController : UIViewController <UINavigationBarDelegate, SDDataManagerDelegate>{

    BOOL missedDownload;

}

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) SDDataManager *dataManager;
@property (strong, nonatomic) IBOutlet UIButton *gameButton;

- (void)dataReady;
- (IBAction)startedTapped:(id)sender;

@end
