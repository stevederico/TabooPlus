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
        NSLog(@"Inserted %i items. Updated %i items.", insertedObjects.count, updatedObjects.count);
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
        
        word.name = [item objectForKey:@"Word"];
        word.adjectives = [item objectForKey:@"Adjectives"];
        
           NSLog(@"Added %@",[word description]);
    }
    

    [[SSManagedObject mainContext] save:nil];

}


-(void) createRecordsWithParseClass:(NSString*)className{
    
    PFQuery *query = [PFQuery queryWithClassName:className];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Parse retrieved %d scores.", objects.count);
            NSManagedObjectContext *context = [SSManagedObject mainContext];
            
            for (PFObject *item in objects) {
                
                if ([self isDBEmpty]) {
                    //Write Straight to Empty DB
                    Word *word = [[Word alloc] initWithEntity: [Word entityWithContext:context] insertIntoManagedObjectContext:context];
                    word.name = [item objectForKey:@"Name"];
                    word.used = [NSNumber numberWithBool:NO];
                    word.objectId = [item objectId];
                    word.adjectives = [item objectForKey:@"Adjectives"];
                    
                }else{
                    //Check
                    if ([self shouldCreateNew:item]) {
                        //write
                        Word *word = [[Word alloc] initWithEntity: [Word entityWithContext:context] insertIntoManagedObjectContext:context];
                        
                        word.used = [NSNumber numberWithBool:NO];
                        word.name = [item objectForKey:@"Name"];
                        word.objectId = [item objectId];
                        word.adjectives = [item objectForKey:@"Adjectives"];
                    };
                
                }
                                
            }

            [context save:nil];
            
        } else {
            //Parse Search Failed
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (BOOL)shouldCreateNew:(PFObject*)object{
    
    NSLog(@"Checking for %@",[object objectForKey:@"Name"]);

    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSString *objectId = [object objectId];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"objectId == %@",objectId];
    [fetch setPredicate:pred];
    [fetch setReturnsDistinctResults:YES];

    
    NSArray *array = [[SSManagedObject mainContext] executeFetchRequest:fetch error:nil];
    if ([array count]>0) {
          NSLog(@"Already There");
            //Check if newer

        
        return NO;
    }else{
        NSLog(@"Writing");
        return YES;
        
    }
    
}

-(BOOL)isDBEmpty{
   
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSArray *array = [[SSManagedObject mainContext] executeFetchRequest:fetch error:nil];
    if ([array count]==0) {
        return YES;
    }else{
        NSLog(@"TOTAL ITEMS %d",[array count]);
        return NO;
    }


}

-(void)resetUsed{
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSArray *array = [[SSManagedObject mainContext] executeFetchRequest:fetch error:nil];
    if ([array count]==0) {
        //DB IS BLANK!
    }else{
        for (Word *item in array) {
            item.used = [NSNumber numberWithBool:NO];
        }
        [[SSManagedObject mainContext] save:nil];
    }
    
    
}

@end
