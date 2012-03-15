//
//  MisoDBLayerGeneric.m
//  MisoUIV3
//
//  Created by HEENA RASTOGI on 3/1/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "MisoDBLayerGeneric.h"

@implementation MisoDBLayerGeneric
-(NSArray*)fetch:(NSString*)entityName fromContext:(NSManagedObjectContext*)context sortedBy:(NSArray*)sortDescriptors filteredBy:(NSPredicate*)predicate
{
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
	NSError *error;
    if(sortDescriptors)
        [fetchRequest setSortDescriptors:sortDescriptors];
    if(predicate)
        [fetchRequest setPredicate:predicate];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [sortDescriptors release];
	[fetchRequest release];
    
	return fetchedObjects;
}

-(NSError*)delete:(NSArray*) managedObjectsArray fromContext:(NSManagedObjectContext*) context
{
    NSError* error = nil;
    for(NSManagedObject* obj in managedObjectsArray)
    {
        [context deleteObject:obj];
    }
    if(![context save:&error])
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
   
    return error;

}

@end
