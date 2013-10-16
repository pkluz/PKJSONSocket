/*
    PKJSONSocket > PKJSONSocketMessage.m
    Copyright (c) 2013 zuui.org (Philip Kluz). All rights reserved.
 */

#import "PKJSONSocketMessage.h"

@interface PKJSONSocketMessage ()

#pragma mark - Properties
@property (nonatomic, strong, readwrite) NSDictionary *dictionaryRepresentation;

@end

@implementation PKJSONSocketMessage

+ (instancetype)messageWithData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data];
}

+ (instancetype)messageWithDictionary:(NSDictionary *)dict
{
    return [[[self class] alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.dictionaryRepresentation = dictionary;
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:nil];
    
    if ([JSONObject isKindOfClass:[NSDictionary class]])
    {
        self = [super init];
        
        if (self)
        {
            self.dictionaryRepresentation = JSONObject;
        }
        
        return self;
    }
    
    return nil;
}

- (NSData *)dataRepresentation
{
    return [NSJSONSerialization dataWithJSONObject:self.dictionaryRepresentation
                                           options:0
                                             error:nil];
}

- (NSDictionary *)dictionaryRepresentation
{
    return self.dictionaryRepresentation;
}

@end
