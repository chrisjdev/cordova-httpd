#import "CordovaHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPLogging.h"

// Log levels: off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;

#define NULL_FD  -1

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
        NSError *error;
        NSString *msg = [NSString stringWithContentsOfFile:[(CordovaHTTPConfig *)config errorPage] encoding:NSUTF8StringEncoding error:&error];
        
        if (msg == nil) {
            msg = @"<html><body>Unexpected error has occured. Click <a onclick=\"window.history.go(-1);\">here</a> to go back</body></html>";
        }
        
        NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        [response setBody:msgData];
        
        NSString *contentLengthStr = [NSString stringWithFormat:@"%lu", (unsigned long)[msgData length]];
        [response setHeaderField:@"Content-Length" value:contentLengthStr];
    }
    
    return [super preprocessErrorResponse:response];
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CordovaHTTPConfig

@synthesize errorPage;


- (id)initWithServer:(HTTPServer *)aServer documentRoot:(NSString *)aDocumentRoot queue:(dispatch_queue_t)q errorPage:(NSString *)aErrorPage;
{
    if ((self = [super initWithServer:aServer documentRoot:aDocumentRoot queue:q])) 
    {
        errorPage = aErrorPage;
    }
    
    return self;
}

@end
