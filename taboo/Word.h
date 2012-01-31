//
//  Word.h
//  WhatWord
//
//  Created by Stephen Derico on 1/30/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : SSManagedObject

@property (nonatomic, retain) id adjectives;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * used;

@end
