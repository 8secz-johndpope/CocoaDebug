//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

#import "ViewController.h"
#import "AFURLSessionManager.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"hello world");
    RedLog(@"hello world red");
    RedLog(@"hello world yellow");
    NSLog(@"%d", 6666666);
    NSLog_UNICODE(@"unicode转换为中文");
    
    [self testHTTP];
    [self test_console_WKWebView];
    [self test_console_UIWebView];
}


- (void)testHTTP {
    
    //1.AFNetworking
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://httpbin.org/get"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(error.localizedDescription);
        } else {
            RedLog(@"%@",response);
            NSLog(responseObject);
        }
    }];
    [dataTask resume];
    
    //2.NSURLConnection
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *apiURLStr =[NSString stringWithFormat:@"https://httpbin.org/get"];
        NSMutableURLRequest *dataRqst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiURLStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        NSHTTPURLResponse *response =[[NSHTTPURLResponse alloc] init];
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:dataRqst returningResponse:&response error:&error];
        NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(error.localizedDescription);
        }else{
            NSLog(responseString);
        }
    });
    
    //3.NSURLSession
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get"]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask_ = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@",responseDictionary);
        }else{
            NSLog(error.localizedDescription);
        }
    }];
    [dataTask_ resume];
}



- (void)test_console_WKWebView {
    WKWebView *webView = [WKWebView new];
    [self.view addSubview:webView];
    [webView loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)test_console_UIWebView {
    UIWebView *webView = [UIWebView new];
    [self.view addSubview:webView];
    [webView loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:[[NSBundle mainBundle] bundleURL]];
}

@end

