/*
    PKJSONSocket > PKJSONSocketDelegate.h
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

#import <Foundation/Foundation.h>

@class PKJSONSocket;
@class PKJSONSocketMessage;

@protocol PKJSONSocketDelegate <NSObject>

@optional
/*
 This method is invoked on your delegate whenever a listening (passive) socket accepts a new incoming
 connection. Please keep in mind that you need to retain the newSocket in some way or it'll be released.
 
 @param socket The listening socket.
 @param newSocket The newly spawned socket connection.
 */
- (void)socket:(PKJSONSocket *)socket didAcceptNewSocket:(PKJSONSocket *)newSocket;

/*
 This method is invoked on your delegate when the connectToHost:onPort:error: method established a
 connection successfully.
 
 @param socket The relevant socket.
 @param host The host the socket established a connection with.
 */
- (void)socket:(PKJSONSocket *)socket didConnectToHost:(NSString *)host;

/*
 This method is invoked on your delegate when the sockets connection is dropped.
 
 @param socket The relevant socket.
 @param error Pointer to an error object containing more information regarding the disconnect.
 */
- (void)socket:(PKJSONSocket *)socket didDisconnectWithError:(NSError *)error;

/*
 This method is invoked on your delegate whenever the socket receives a message.
 
 @param socket The relevant socket.
 @param message The message that was received.
 */
- (void)socket:(PKJSONSocket *)socket didReceiveMessage:(PKJSONSocketMessage *)dictionary;

@end
