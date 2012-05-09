//
//  MisoDBLayerGeneric.h
//  MisoUIV3
//
//  Created by HEENA RASTOGI on 3/1/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MisoDBLayerGeneric : NSObject;
+(NSError*)deleteManagedObjects:(NSArray*) managedObjectsArray 
                  withinContext:(NSManagedObjectContext*) context;
+(NSError*)insertManagedObjects:(NSArray*) managedObjArr 
                  withinContext:(NSManagedObjectContext*) context;
+(NSArray*)fetchManagedObjectsFromEntityWithName:(NSString*) entityName 
                                   withinContext:(NSManagedObjectContext*) context 
                                        sortedBy:(NSArray*) sortDescriptors 
                                      filteredBy:(NSPredicate*) predicate;
+(NSManagedObject*) allocEntityTypeObj:(NSString*) entityName 
                         withinContext:(NSManagedObjectContext*) context;

@end
