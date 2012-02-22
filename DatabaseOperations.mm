//
//  DatabaseOperations.mm
//  MisoUIV3
//
//  Created by Heena Rastogi on 6/21/11.
//  Copyright 2011 Miso Media Inc. All rights reserved.
//

#import "DatabaseOperations.h"
#import "MisoUIV3AppDelegate.h"
#import "DatabaseTablesHeader.h"
#import "StringsDefine.h"
#import "Instrument.h"

@implementation DatabaseOperations
//--------------------------------------------------------------------------------
// get data from database

+(NSArray*)getDataFromDB:(NSString*)table_name 
{
	NSManagedObjectContext *context = [(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:table_name 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
	return fetchedObjects;
}

+(NSArray *)getInstrumentDataFromDB:(NSString *)table_name
{
    NSMutableArray *instrumentArray = [[NSMutableArray alloc] init];
    NSArray *instrumentsDescriptionObjects = [[self class] getDataFromDB:table_name];

    for(instruments_description *instrument in instrumentsDescriptionObjects)
    {
        [instrumentArray addObject:[Instrument createInstrumentFromObjectType:instrument]];
    }
    NSArray *instrumentObjects = [NSArray arrayWithArray:instrumentArray];
    [instrumentArray release];
    return instrumentObjects;
}

+(NSArray *)getInstrumentDataFromDBAsc:(NSString *)table_name byKey:(NSString *)key asc:(BOOL)ascending_order
{
    NSMutableArray *instrumentArray = [[NSMutableArray alloc] init];
    NSArray *instrumentsDescriptionObjects = [[self class] getDataFromDBAsc:table_name byKey:key asc:ascending_order];
    
    for(instruments_description *instrument in instrumentsDescriptionObjects)
    {
        [instrumentArray addObject:[Instrument createInstrumentFromObjectType:instrument]];
    }
    NSArray *instrumentObjects = [NSArray arrayWithArray:instrumentArray];
    [instrumentArray release];
    return instrumentObjects;
}


//--------------------------------------------------------------------------------
// get data in ascending or descending order from database
// P.S: send the boolean value "ascending_order" NO if we want data in descending order

+(NSArray*)getDataFromDBAsc:(NSString*)table_name byKey:(NSString*)key asc:(BOOL)ascending_order
{
	NSManagedObjectContext* context = [(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:table_name inManagedObjectContext:context];
	NSFetchRequest *fetch_request = [[NSFetchRequest alloc] init];
	[fetch_request setEntity:entity];
	
    
	NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending_order];
	NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
	[fetch_request setSortDescriptors:sort_descriptors];
	
	
	NSError* error = nil;
	NSArray* fetched_objects = [context executeFetchRequest:fetch_request error:&error]; 
	
	[sort_descriptors release]; 
	sort_descriptors = nil;
	[sort_descriptor release];
	sort_descriptor = nil;
	[fetch_request release]; 
	
	return fetched_objects;
	
}

/*+(NSManagedObject)updateDataInDB:(NSString*)table_name withPredicate:(NSString*) predicate_str value:(id)value initKey:(NSString*) key
 {
 
 NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
 NSEntityDescription *entity = [NSEntityDescription entityForName:table_name inManagedObjectContext:context];
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 [request setEntity:entity];
 
 NSPredicate *predicate = [NSPredicate predicateWithFormat:predicate_str, value];
 [request setPredicate:predicate];
 
 NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
 NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
 [request setSortDescriptors:sortDescriptors];
 [sortDescriptors release]; sortDescriptors = nil;
 [sortDescriptor release]; sortDescriptor = nil;
 
 NSError * error = nil;
 NSManagedObject* fetch_obj = [[context executeFetchRequest:request error:&error] objectAtIndex:0];
 [request release]; 
 request = nil;
 
 return fetch_obj;
 instrument.built_in = [NSNumber numberWithBool:true];
 //NSLog(@"instrument_id:%@",instrument.instrument_id);
 NSError *errorr;
 [context save:&errorr];
 [request release];
 
 }*/
+(BOOL)insertDataInDB:(NSString*)table_name ofType:(NSManagedObject*)table_object
{
    
	NSManagedObjectContext* context = [(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	[context insertObject:table_object];
    
    
	NSError* error;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
    
    //	NSLog(@"Inserting obj in db:%@",table_object);
	return YES;
}

/*+(id)getAnObjectFromDB:(NSString*)table_name unique_id:(int)object_id
 {
 }*/

//----------------------------------------------------------------------------
// Call this function to allocate memory to any object of type NSManagedObject
//APPLE MUST DIE ... i know i am assigning nil context but that's the only way to do this .. acc to STACK OVERFLOW.

+(NSManagedObject*) allocEntityTypeObj:(NSString*)table_name
{
	
	NSManagedObjectContext* context = [(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription* entity = [NSEntityDescription entityForName:table_name inManagedObjectContext:context];
	NSManagedObject* entity_obj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
	return entity_obj;
}

//---------------------------------------------------------------------------
// Custom Delete calls.

+(BOOL)deleteInstrument:(int)instrument_id
{
	NSManagedObjectContext *thecontext = [(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"instruments_description" inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"instrument_id == %d", instrument_id];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"instrument_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release]; sortDescriptors = nil;
	[sortDescriptor release]; sortDescriptor = nil;
	
	NSError * error = nil;
	instruments_description* instrument = [[thecontext executeFetchRequest:request error:&error] objectAtIndex:0];
	[request release]; 
	request = nil;
	
	instrument.built_in = [NSNumber numberWithBool:true];
	//NSLog(@"instrument_id:%@",instrument.instrument_id,instrument.instrument_maker);
	
	[thecontext deleteObject:instrument];
	if (![thecontext save:&error]) {
		//NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
    else
    {
        //NSLog(@"Context Saved in App Delegate: ");
    }
	
	[request release];
	return YES;
}

// ---------Delete Users Access from user info table for given part
+(BOOL)deleteUserAccessForSong:(int)part_id current_user_id:(int)user_id
{
	//NSLog(@"delete song");
	//user_id = -42;
	//NSLog(@"part_id:%d annd user_id:%d",part_id,user_id);
	BOOL result = YES;
    
	NSManagedObjectContext *thecontext =[(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:user_purchase_table inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id == %d AND user_id == %d", part_id,user_id];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"product_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [sortDescriptor release];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release]; 
	sortDescriptors = nil;
	
	
	NSError * error = nil;
    NSArray *fetchedData = [thecontext executeFetchRequest:request error:&error];
    
    user_info* song = nil;
    if([fetchedData count])
    {
        song = [fetchedData objectAtIndex:0];
    }
    else
    {
        result = NO;
    }
    
	//NSLog(@"song deleted:%d user_id:%d",[song.product_id intValue],[song.user_id intValue]);
	
    if (song)[thecontext deleteObject:song];
	
    if (![thecontext save:&error]) {
		//NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		result = NO;
	}
	
	[request release];
	request = nil;
	
	return result;
}

// ------ delete song from core data
+(BOOL)deleteSong:(int)part_id
{
	
	//NSLog(@"Deleting song........");
	//NSLog(@"part_id:%d ",part_id);
	
	
	// Saving date of purchase
	
    BOOL result = YES;
    
	MisoUIV3AppDelegate* appDelegate = (MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *thecontext = [appDelegate managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:song_table inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"part_id == %d",part_id];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"part_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [sortDescriptor release];
	[request setSortDescriptors:sortDescriptors];
	
    
	
	NSError * error = nil;
    NSArray *fetchedData = [thecontext executeFetchRequest:request error:&error];
    song_description* song = nil;
    if([fetchedData count])
    {
        song = [fetchedData objectAtIndex:0];
		appDelegate.dateOfPurchase_song = song.date_purchased;
    }
    else
    {
        result = NO;
    }
    
    if (song) {
        appDelegate.dateOfPurchase_song = song.date_purchased;
        [thecontext deleteObject:song];
    }
    
	if (![thecontext save:&error]) {
		//NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		result = NO;
	}
	
	
	[sortDescriptors release]; 
	sortDescriptors = nil;
	[request release]; 
	request = nil;
	[self deleteTablature:part_id];
	return result;
}


//------- delete Tablature from core data
+(BOOL)deleteTablature:(int)part_id
{
    BOOL result = YES;
    
	NSManagedObjectContext *thecontext = [(MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tab_table inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"part_id == %d", part_id];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"part_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release]; sortDescriptors = nil;
	[sortDescriptor release]; sortDescriptor = nil;
	
	NSError * error = nil;
    NSArray *fetchedData = [thecontext executeFetchRequest:request error:&error];
    tablature_description *tab = nil;
    if([fetchedData count])
    {
        tab = [fetchedData objectAtIndex:0];
    }
    else
    {
        result = NO;
    }
	
    [request release]; 
	request = nil;
	
	
	//NSLog(@"tab deleted:%d",tab.part_id);
    
	if (tab)[thecontext deleteObject:tab];
    
	if (![thecontext save:&error]) {
		//NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		result = NO;
	}
	
	[request release];
    
	return result;
}

@end
