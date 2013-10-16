/*
    PKJSONSocket > PKJSONSocket.h
    Copyright (c) 2013 zuui.org (Philip Kluz). All rights reserved.
 */

#import "PKJSONSocket.h"

@interface PKJSONSocket () <GCDAsyncSocketDelegate>

@property (nonatomic, strong, readwrite) GCDAsyncSocket *internalSocket;

@end

@implementation PKJSONSocket

+ (instancetype)socketWithDelegate:(id)delegate
{
    return [[[self class] alloc] initWithDelegate:delegate];
}

+ (instancetype)socketWithInternalSocket:(GCDAsyncSocket *)socket
{
    return [[[self class] alloc] initWithInternalSocket:socket];
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

- (instancetype)initWithInternalSocket:(GCDAsyncSocket *)socket
{
    self = [super init];
    
    if (self)
    {
        self.internalSocket = socket;
        [socket synchronouslySetDelegate:self];
    }
    
    return self;
}

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
    self.internalSocket.delegate = nil;
    self.internalSocket = nil;
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
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)socket didAcceptNewSocket:(GCDAsyncSocket *)newInternalSocket
{
    if (socket != self.internalSocket)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(socket:didAcceptNewSocket:)])
    {
        PKJSONSocket *newSocket = [PKJSONSocket socketWithInternalSocket:newInternalSocket];
        [self.delegate socket:self didAcceptNewSocket:newSocket];
    }
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (socket != self.internalSocket)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(socket:didConnectToHost:)])
    {
        [self.delegate socket:self didConnectToHost:host];
    }
    
    [self.internalSocket readDataToData:[GCDAsyncSocket CRLFData]
                            withTimeout:-1
                                    tag:0];
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
    
    [self.internalSocket readDataToData:[GCDAsyncSocket CRLFData]
                            withTimeout:-1
                                    tag:0];
}

@end
