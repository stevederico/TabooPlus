//
//  SDParseDataManager.h
//  taboo
//
//  Created by Stephen Derico on 1/27/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDataManager : NSObject
-(void) createRecordsWithPlistNamed:(NSString*)filename;
@end
