/*
 PKJSONSocket > PKJSONSocket.m
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

#import "PKJSONSocket.h"

@interface PKJSONSocket () <GCDAsyncSocketDelegate>

@property (nonatomic, strong, readwrite) GCDAsyncSocket *internalSocket;

@end

@implementation PKJSONSocket

#pragma mark - Initialization

+ (instancetype)socketWithDelegate:(id<PKJSONSocketDelegate>)delegate
{
    return [[[self class] alloc] initWithDelegate:delegate];
}

+ (instancetype)socketWithGCDAsyncSocket:(GCDAsyncSocket *)socket
{
    return [[[self class] alloc] initWithGCDAsyncSocket:socket];
}

- (instancetype)initWithDelegate:(id<PKJSONSocketDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithGCDAsyncSocket:(GCDAsyncSocket *)socket
{
    self = [super init];
    
    if (self)
    {
        self.internalSocket = socket;
    }
    
    return self;
}

#pragma mark - API

- (void)connectToHost:(NSString *)IP
               onPort:(uint16_t)port
                error:(NSError *__autoreleasing *)error
{
    if (!self.internalSocket)
    {
        self.internalSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                         delegateQueue:dispatch_get_main_queue()];
        [self.internalSocket connectToHost:IP onPort:port error:error];
    }
}

- (void)disconnect
{
    [self.internalSocket disconnect];
}

- (void)listenOnPort:(uint16_t)port error:(NSError *__autoreleasing *)error
{
    if (!self.internalSocket)
    {
        self.internalSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                         delegateQueue:dispatch_get_main_queue()];
        [self.internalSocket acceptOnPort:port error:error];
    }
}

- (void)send:(PKJSONSocketMessage *)message
{
    [self.internalSocket writeData:[message dataRepresentation]
                       withTimeout:-1
                               tag:0];
    [self.internalSocket writeData:[GCDAsyncSocket CRLFData]
                       withTimeout:-1
                               tag:0];
}

- (BOOL)isConnected
{
    return self.internalSocket.isConnected;
}

#pragma mark - Helper

- (void)readNextMessage
{
    [self.internalSocket readDataToData:[GCDAsyncSocket CRLFData]
                            withTimeout:-1
                                    tag:0];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)socket didAcceptNewSocket:(GCDAsyncSocket *)newInternalSocket
{
    if (socket != self.internalSocket)
    {
        return;
    }
    
    PKJSONSocket *newSocket = [PKJSONSocket socketWithGCDAsyncSocket:newInternalSocket];
    newInternalSocket.delegate = newSocket;
    
    if ([self.delegate respondsToSelector:@selector(socket:didAcceptNewSocket:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate socket:self didAcceptNewSocket:newSocket];
        });
    }
    
    [newSocket readNextMessage];
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (socket != self.internalSocket)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(socket:didConnectToHost:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate socket:self didConnectToHost:host];
        });
    }
    
    [self readNextMessage];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error
{
    if (socket != self.internalSocket)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(socket:didDisconnectWithError:)])
    {
        [self.delegate socket:self didDisconnectWithError:error];
    }
    
    self.internalSocket.delegate = nil;
    self.internalSocket = nil;
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    if (socket != self.internalSocket)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PKJSONSocketMessage *message = [PKJSONSocketMessage messageWithData:data];
        
        if (message && [self.delegate respondsToSelector:@selector(socket:didReceiveMessage:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate socket:self didReceiveMessage:message];
            });
        }
    });
    
    [self readNextMessage];
}

@end
