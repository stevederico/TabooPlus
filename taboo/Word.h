//
//  Word.h
//  WhatWord
//
//  Created by Stephen Derico on 2/1/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : SSManagedObject

@property (nonatomic, retain) id adjectives;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * used;
@property (nonatomic, retain) NSString * objectId;

@end
