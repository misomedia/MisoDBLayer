//
//  DatabaseOperations.h
//  MisoUIV3
//
//  Created by Heena Rastogi on 6/21/11.
//  Copyright 2011 Miso Media Inc. All rights reserved.
//




@interface DatabaseOperations : NSObject 
{
	
}

+(NSManagedObject*) allocEntityTypeObj:(NSString*)table_name;
+(NSArray*)getInstrumentDataFromDB:(NSString*)table_name;
+(NSArray *)getInstrumentDataFromDBAsc:(NSString *)table_name byKey:(NSString *)key asc:(BOOL)ascending_order;
+(NSArray*)getDataFromDB:(NSString*)table_name;
+(NSArray*)getDataFromDBAsc:(NSString*)table_name byKey:(NSString*)key asc:(BOOL)ascending_order;
+(BOOL)insertDataInDB:(NSString*)table_name ofType:(NSManagedObject*)table_object;
+(BOOL)deleteTablature:(int)part_id;
+(BOOL)deleteSong:(int)part_id;
+(BOOL)deleteInstrument:(int)instrument_id;
+(BOOL)deleteUserAccessForSong:(int)part_id current_user_id:(int)user_id;


@end
