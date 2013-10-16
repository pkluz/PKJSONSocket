#PKJSONSocket

PKJSONSocket aims to simplify network communications. It's a delightful wrapper around _[CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket)_, abstracting away complex data flow into an easy to use API. Instead of dealing with the bits and bytes yourself, PKJSONSocket offers you UTF-8 encoded JSON strings.

## Installation (CocoaPods)
```
pod 'PKJSONSocket'
```

## Usage

Simply `#import "PKJSONSocket.h"` and...

- **Connect** to a remote host:

    ``` objective-c
    PKJSONSocket *socket = [PKJSONSocket socketWithDelegate:self];
    [socket connectToHost:@"127.0.0.1" onPort:3333 error:nil];
    ```
    
- **Listen** for incoming connections:
    ``` objective-c
    [socket listenOnPort:3333 error:nil];
    ```

- Watch for **incoming data** by conforming to the `<PKJSONSocketDelegate>` protocol:
    ``` objective-c
    - (void)socket:(PKJSONSocket *)socket didReceiveMessage:(PKJSONSocketMessage *)msg
    {
		NSLog(@"Received: %@", [msg dictionaryRepresentation]);
    }
    ```
    
- **Send** messages down the wire:
    ``` objective-c
    NSDictionary *dict = @{ @"message" : @"The answer is 42." };
    PKJSONSocketMessage *msg = [PKJSONSocketMessage messageWithDictionary:dict];
    [socket send:msg];
    ```
   
**Note:** Do **NOT** use the same socket object to connect to remote hosts and listen for incoming connections. It will not work.

## Requirements
- iOS 6.0 or later
- OS X 10.8 or later

## Todo
- Wrap CocoaAsynSocket's **SSL support** into an easy to use API.

## Changelog

**0.0.1** (Oct 16th, 2013)
- First public release.

##License

> PKJSONSocket - Copyright (C) 2013 Philip Kluz (Philip.Kluz@zuui.org)
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

