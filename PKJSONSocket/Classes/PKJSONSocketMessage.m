/*
    PKJSONSocket > PKJSONSocketMessage.m
    Copyright (c) 2013 zuui.org (Philip Kluz). All rights reserved.
 
    The MIT License (MIT)
 
    Copyright (c) 2013 Philip Kluz
 
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:
 
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
 
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "PKJSONSocketMessage.h"

@interface PKJSONSocketMessage ()

#pragma mark - Properties
@property (nonatomic, strong, readwrite) NSDictionary *dictionary;

@end

@implementation PKJSONSocketMessage

#pragma mark - Initialization

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
        self.dictionary = dictionary;
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
            self.dictionary = JSONObject;
        }
        
        return self;
    }
    
    return nil;
}

#pragma mark - Accessors

- (NSData *)dataRepresentation
{
    return [NSJSONSerialization dataWithJSONObject:self.dictionaryRepresentation
                                           options:0
                                             error:nil];
}

- (NSDictionary *)dictionaryRepresentation
{
    return _dictionary;
}

@end
