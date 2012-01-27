//
//  ViewController.h
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@interface ViewController : UIViewController {
    

}

@property (nonatomic, strong) NSArray *contentArray;

- (IBAction)startedTapped:(id)sender;

@end
