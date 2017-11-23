#import "CordovaHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPLogging.h"

// Log levels: off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;


@implementation CordovaHTTPConnection

- (NSData *)preprocessErrorResponse:(HTTPMessage *)response
{
    HTTPLogTrace();
    
    // Override me to customize the error response headers
    // You'll likely want to add your own custom headers, and then return [super preprocessErrorResponse:response]
    // 
    // Notes:
    // You can use [response statusCode] to get the type of error.
    // You can use [response setBody:data] to add an optional HTML body.
    // If you add a body, don't forget to update the Content-Length.
    
    if ([response statusCode] == 404)
    {
        NSString *msg = @"<html><body>Error 404 - Not Found</body></html>";
        NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        [response setBody:msgData];
        
        NSString *contentLengthStr = [NSString stringWithFormat:@"%lu", (unsigned long)[msgData length]];
        [response setHeaderField:@"Content-Length" value:contentLengthStr];
    }
    
    return [super preprocessErrorResponse:response];
}

@end