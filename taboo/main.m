//
//  main.m
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [Parse setApplicationId:@"X5FFPKcILn0uKBEvHKcBealXqo7ER6n8X5FTxH1W" 
                      clientKey:@"7aGwAcBnygeldZdJf2tLgKZORSCBXHrSWK8Ims1C"];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
