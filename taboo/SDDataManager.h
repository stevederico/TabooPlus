//
//  SDParseDataManager.h
//  taboo
//
//  Created by Stephen Derico on 1/27/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDDataManagerDelegate <NSObject>

-(void)dataReady;

@end



@interface SDDataManager : NSObject
@property (nonatomic, weak) id <SDDataManagerDelegate> delegate;


-(void) createRecordsWithPlistNamed:(NSString*)filename;
-(void) createRecordsWithParseClass:(NSString*)className;
-(BOOL)shouldCreateNew:(PFObject*)object;
-(BOOL)isDBEmpty;
-(void)resetUsed;
@end
