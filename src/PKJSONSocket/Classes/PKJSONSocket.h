/*
    PKJSONSocket > PKJSONSocket.h
    Copyright (c) 2013 zuui.org (Philip Kluz). All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "PKJSONSocketMessage.h"

typedef void (^PKJSONSocketConnectHandler)(NSError *error);

@protocol PKJSONSocketDelegate;

@interface PKJSONSocket : NSObject

#pragma mark - Properties
@property (nonatomic, weak, readwrite) id<PKJSONSocketDelegate> delegate;

#pragma mark - Methods
+ (instancetype)socketWithDelegate:(id)delegate;

- (void)connectToHost:(NSString *)IP onPort:(uint16_t)port error:(NSError *__autoreleasing *)error;
- (void)listenOnPort:(uint16_t)port error:(NSError *__autoreleasing *)error;
- (void)disconnect;

- (void)send:(PKJSONSocketMessage *)message;

@end

@protocol PKJSONSocketDelegate <NSObject>

- (void)socket:(PKJSONSocket *)socket didAcceptNewSocket:(PKJSONSocket *)newSocket;

- (void)socket:(PKJSONSocket *)socket didConnectToHost:(NSString *)host;
- (void)socket:(PKJSONSocket *)socket didDisconnectFromHost:(NSString *)host;

- (void)socket:(PKJSONSocket *)socket didReceiveMessage:(PKJSONSocketMessage *)dictionary;

@end