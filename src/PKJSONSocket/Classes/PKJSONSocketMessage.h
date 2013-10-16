/*
    PKJSONSocket > PKJSONSocketMessage.h
      Copyright (c) 2013 zuui.org (Philip Kluz). All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface PKJSONSocketMessage : NSObject

#pragma mark - Properties

#pragma mark - Methods

/*
 This method is used when initializing a message manually in order for it to be dispatched via the socket.
 */
+ (instancetype)messageWithDictionary:(NSDictionary *)dict;

/* 
 This method is used by the PKJSONSocket in order to return a message that was received as data.
 */
+ (instancetype)messageWithData:(NSData *)data;

- (NSDictionary *)dictionaryRepresentation;
- (NSData *)dataRepresentation;

@end
