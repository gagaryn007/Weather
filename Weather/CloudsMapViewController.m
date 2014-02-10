//
//  CloudsMapViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 03.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CloudsMapViewController.h"

@interface CloudsMapViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CloudsMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlStr = @"http://maps.google.com";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
