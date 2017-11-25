#import "HTTPServer.h"

@interface CordovaHTTPServer : HTTPServer
{
    NSString *errorPage;
}

- (NSString *)errorPage;
- (void)setErrorPage:(NSString *)value;

@end
