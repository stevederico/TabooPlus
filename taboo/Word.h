//
//  Word.h
//  taboo
//
//  Created by Stephen Derico on 1/27/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : SSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * adj1;
@property (nonatomic, retain) NSString * adj2;
@property (nonatomic, retain) NSString * adj3;
@property (nonatomic, retain) NSString * adj4;
@property (nonatomic, retain) NSString * adj5;

@end
