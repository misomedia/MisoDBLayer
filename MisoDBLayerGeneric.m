//
//  MisoDBLayerGeneric.m
//  MisoUIV3
//
//  Created by HEENA RASTOGI on 3/1/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "MisoDBLayerGeneric.h"

@implementation MisoDBLayerGeneric

+(NSArray*)fetchManagedObjectsFromEntityWithName:(NSString*)entityName 
                                   withinContext:(NSManagedObjectContext*)context 
                                        sortedBy:(NSArray*) sortDescriptors 
                                      filteredBy:(NSPredicate*)predicate
{
    [sortDescriptors retain];

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

+(NSError*)deleteManagedObjects:(NSArray*) managedObjectsArray 
                  withinContext:(NSManagedObjectContext*) context
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

+(NSError*)insertManagedObjects:(NSArray*) managedObjArr
                  withinContext:(NSManagedObjectContext*) context
{
    
    for(NSManagedObject* obj in managedObjArr)
            [context insertObject:obj];
    
    
	NSError* error = nil;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		
	}
    
	return error;
}

+(NSManagedObject*) allocEntityTypeObj:(NSString*) entityName 
                         withinContext:(NSManagedObjectContext*) context
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];	
    NSManagedObject* entity_obj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    return entity_obj;
}
@end
