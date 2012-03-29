//
//  MisoDBLayerGeneric.h
//  MisoUIV3
//
//  Created by HEENA RASTOGI on 3/1/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MisoDBLayerGeneric : NSObject;
-(NSArray*)fetch:(NSString*)entityName fromContext:(NSManagedObjectContext*)context sortedBy:(NSArray*)sortDescriptors filteredBy:(NSPredicate*)predicate;
-(NSError*)delete:(NSArray*) managedObjectsArray fromContext:(NSManagedObjectContext*) context;
+(NSError*)insert:(NSArray*)managedObjArr inContext:(NSManagedObjectContext*) context;
@end
