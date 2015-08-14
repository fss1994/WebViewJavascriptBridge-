//
//  ViewController.m
//  02-JS在iOS应用中的简单使用
//
//  Created by teacher on 15/3/11.
//  Copyright (c) 2015年 itheima. All rights reserved.
//
#import "WebViewJavascriptBridge.h"

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController


- (void)testLoadHTML2
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ExampleApp" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}



- (void)viewWillAppear:(BOOL)animated{
    
    if (_bridge) { return; }

    // 似乎是 打开调试信息 log
    [WebViewJavascriptBridge enableLogging];
    
    //    这是使用类方法创建一个WebViewJavascriptBridge对象。其中有一个block类型的handle。这个handle主要是用来接收JavaScript里面通过send方法传过来的消息的，这里的handle里面的参数与JavaScript中send方法里面的参数对应。
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"oc 接受到了data -- %@", data);
        responseCallback(@"消息从oc 中响应");
    
    }];
    
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"测试回调数据: %@", data);
        responseCallback(@"测试回调数据---------");
    }];
    
    // 发送一条消息给js
    [_bridge send:@"在 webView 加载前 发送的 消息" responseCallback:^(id responseData) {
        NSLog(@"oc 受到 加载前的回应------------- %@", responseData);
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"在准备好之前" }];

    // 再发送一条 消息给js
    [_bridge send:@"在 webView 加载后 发送的 消息"];
    
        [self testLoadHTML2];
    
//    [self renderButtons:self.webView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}


//
//- (void)renderButtons:(UIWebView*)webView {
//    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
//    
//    // oc 发送消息按钮
//    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [messageButton setTitle:@"Send message" forState:UIControlStateNormal];
//    [messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:messageButton aboveSubview:webView];
//    messageButton.frame = CGRectMake(10, 414, 100, 35);
//    messageButton.titleLabel.font = font;
//    messageButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    
//    //
//    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
//    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:callbackButton aboveSubview:webView];
//    callbackButton.frame = CGRectMake(110, 414, 100, 35);
//    callbackButton.titleLabel.font = font;
//    
//    // 刷新按钮
//    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
//    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:reloadButton aboveSubview:webView];
//    reloadButton.frame = CGRectMake(210, 414, 100, 35);
//    reloadButton.titleLabel.font = font;
//}
//
//
//// oc向 js中发送消息
//- (void)sendMessage:(id)sender {
//    [_bridge send:@"A string sent from ObjC to JS" responseCallback:^(id response) {
//        NSLog(@"sendMessage got response: %@", response);
//    }];
//}
//
//// oc调用 js中已经注册的方法
//- (void)callHandler:(id)sender {
//    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
//    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
//        NSLog(@"testJavascriptHandler responded: %@", response);
//    }];
//}



@end







