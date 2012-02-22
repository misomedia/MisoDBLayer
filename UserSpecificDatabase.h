//
//  UserSpecificDatabase.h
//  MisoUIV3
//
//  Created by Heena Rastogi on 9/4/11.
//  Copyright 2011 Miso Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSpecificDatabase : NSObject {
	
}

+(int)getIntegerIdFromString:(NSString*)str;
+(NSArray*)fetchSongsofCurrentUser:(int)user_id;
+(NSMutableArray*)fetchPurchasedSongsOfCurrentUser:(int)user_id ofType:(NSString*)type;
+(NSArray*)fetchInstrumentsofCurrentUser:(int)user_id;
@end
