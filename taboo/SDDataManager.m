//
//  SDParseDataManager.m
//  taboo
//
//  Created by Stephen Derico on 1/27/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "Word.h"
#import "SDDataManager.h"

@implementation SDDataManager
- (id) init{
    self = [super init];
    SSManagedObjectContextObserver *observer = [[SSManagedObjectContextObserver alloc] init];
    observer.observationBlock = ^(NSSet *insertedObjects, NSSet *updatedObjects) {
        NSLog(@"Inserted %i Words. Updated %i Words.", insertedObjects.count, updatedObjects.count);
    };
    [[SSManagedObject mainContext] addObjectObserver:observer];

    return self;
}

-(void) createRecordsWithPlistNamed:(NSString*)filename{
    
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSArray *contentArray = [NSArray arrayWithContentsOfFile:file];
    NSLog(@"%@",[contentArray  description]);
    
    for (NSDictionary *item in contentArray) {
        
        Word *word = [[Word alloc] initWithEntity: [Word entityWithContext:[SSManagedObject mainContext]] insertIntoManagedObjectContext:[SSManagedObject mainContext]];
        
        word.name = [item valueForKey:@"Word"];
        word.adj1 = [item valueForKey:@"Adjective 1"];
        word.adj1 = [item valueForKey:@"Adjective 2"];
        word.adj1 = [item valueForKey:@"Adjective 3"];
        
    }
    

    [[SSManagedObject mainContext] save:nil];

}
@end
