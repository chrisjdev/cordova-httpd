#import "CordovaHTTPServer.h"
#import "CordovaHTTPConnection.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation CordovaHTTPServer

- (NSString *)errorPage
{
    __block NSString *result;
    
    dispatch_sync(serverQueue, ^{
        result = errorPage;
    });
    
    return result;
}

- (void)setErrorPage:(NSString *)value
{
    //HTTPLogTrace();
    
    NSString *valueCopy = [value copy];
    
    dispatch_async(serverQueue, ^{
        errorPage = valueCopy;
    });
    
}

- (HTTPConfig *)config
{
    // Override me if you want to provide a custom config to the new connection.
    // 
    // Generally this involves overriding the HTTPConfig class to include any custom settings,
    // and then having this method return an instance of 'MyHTTPConfig'.
    
    // Note: Think you can make the server faster by putting each connection on its own queue?
    // Then benchmark it before and after and discover for yourself the shocking truth!
    // 
    // Try the apache benchmark tool (already installed on your Mac):
    // $  ab -n 1000 -c 1 http://localhost:<port>/some_path.html
    
    return [[CordovaHTTPConfig alloc] initWithServer:self documentRoot:documentRoot queue:connectionQueue errorPage:errorPage];
}

@end
