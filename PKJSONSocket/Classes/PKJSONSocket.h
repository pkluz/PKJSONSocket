/*
    PKJSONSocket > PKJSONSocket.h
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

@import Foundation;
@import CocoaAsyncSocket;

#import "PKJSONSocketDelegate.h"
#import "PKJSONSocketMessage.h"

typedef void (^PKJSONSocketConnectHandler)(NSError *error);

@interface PKJSONSocket : NSObject

#pragma mark - Properties
@property (nonatomic, weak, readwrite) id<PKJSONSocketDelegate> delegate;
@property (nonatomic, assign, readwrite, getter = isConnected) BOOL connected;

#pragma mark - Methods
/*
 Initializes a new socket and sets the delegate.
 
 @param delegate A delegate object conforming to the PKJSONSocketDelegate protocol.
 */
+ (instancetype)socketWithDelegate:(id<PKJSONSocketDelegate>)delegate;

/*
 Connects to the given, identified by IP.
 
 @param IP The IP of the host to connect to.
 @param port The port to use for the connection.
 @param error Pointer to an error object in case something went wrong.
 */
- (void)connectToHost:(NSString *)IP onPort:(uint16_t)port error:(NSError *__autoreleasing *)error;

/*
 Allows the socket to listen for new incoming connections. Note: connectToHost:onPort:error: and
 listenOnPort:error: are mutually exclusive. I.e. your socket it either a passive (listening) socket
 or an active (connecting) socket.
 
 @param IP The port to accept connections on. Root priviledges required for certain ports.
 @param error Pointer to an error object in case something went wrong.
 */
- (void)listenOnPort:(uint16_t)port error:(NSError *__autoreleasing *)error;

/*
 Disconnects the socket.
 */
- (void)disconnect;

/*
 Sends a message down the wire to the host the socket is connected to. CRLF separated messages.
 
 @param message The message that's going to be sent.
 */
- (void)send:(PKJSONSocketMessage *)message;

@end
