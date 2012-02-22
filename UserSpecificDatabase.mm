//
//  UserSpecificDatabase.mm
//  MisoUIV3
//
//  Created by Heena Rastogi on 9/4/11.
//  Copyright 2011 Miso Media Inc. All rights reserved.
//

#import "UserSpecificDatabase.h"
#import "MisoUIV3AppDelegate.h"
#import "DatabaseTablesHeader.h"
#import "StringsDefine.h"
#import "Instrument.h"

@implementation UserSpecificDatabase

+(NSMutableArray*)fetchPurchasesOfCurrentUser:(int)user_id ofType:(NSString*)type
{
	
	MisoUIV3AppDelegate* appDelegate = (MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *thecontext = [appDelegate managedObjectContext];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:user_purchase_table inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %d", user_id];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"product_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError * error = nil;
	NSArray* user_purchases = [thecontext executeFetchRequest:request error:&error];

	NSMutableArray* userPartsArr = [NSMutableArray array];
	for(user_info* current_user in user_purchases)
	{
		if([current_user.product_type isEqualToString:type])
		{
			[userPartsArr addObject:current_user.product_id];
		}
	}
	NSError *errorr;
	[thecontext save:&errorr];
	[request release];
	
	
	return userPartsArr;
	
}

+(NSArray*)fetchSongsofCurrentUser:(int)user_id
{
	
	NSMutableArray* userPartsArr = [self fetchPurchasesOfCurrentUser:user_id ofType:@"part"];
	
	MisoUIV3AppDelegate* appDelegate = (MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *thecontext = [appDelegate managedObjectContext];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:song_table inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"part_id IN %@", userPartsArr];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"part_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [sortDescriptor release];

	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	
	NSError * error = nil;
	NSArray* userSongs = [thecontext executeFetchRequest:request error:&error];
	[request release]; 
	
	NSError *errorr;
	[thecontext save:&errorr];
	
	return userSongs;
}


// Function to fetch instruments
+(NSArray*)fetchInstrumentsofCurrentUser:(int)user_id
{
	
	NSMutableArray* instArr = [self fetchPurchasesOfCurrentUser:user_id ofType:@"instrument"];
	
	MisoUIV3AppDelegate* appDelegate = (MisoUIV3AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *thecontext = [appDelegate managedObjectContext];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:instrument_table inManagedObjectContext:thecontext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"instrument_id IN %@", instArr];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"instrument_type_idx" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [sortDescriptor release];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release]; 
	
	
	NSError * error = nil;
	NSArray* userInstruments = [thecontext executeFetchRequest:request error:&error];
	[request release]; 
	
	NSError *errorr;
	[thecontext save:&errorr];
    
    NSMutableArray *instrumentObjects = [[NSMutableArray alloc] init];
    for(instruments_description *instrument in userInstruments)
    {
        Instrument *instrumentObject = [Instrument createInstrumentFromObjectType:instrument];
        [instrumentObjects addObject:instrumentObject];
    }
	
    userInstruments = [NSArray arrayWithArray:instrumentObjects];
    [instrumentObjects release];
	
    return userInstruments;
}




// General function , converts strings to integer
// CL: what's wrong with [str intValue] ?
+(int)getIntegerIdFromString:(NSString*)str
{
	
	NSNumberFormatter* f =[[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber* myNumber = [f numberFromString:str];
	[f release];
	
	return [myNumber intValue];					  
	
}

// CL: warning silence
+(NSMutableArray*)fetchPurchasedSongsOfCurrentUser:(int)user_id ofType:(NSString*)type{return nil;}


@end
