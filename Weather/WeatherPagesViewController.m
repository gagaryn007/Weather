//
//  ViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 24.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherPagesViewController.h"
#import "ColorSelector.h"

@interface WeatherPagesViewController ()

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) PageContentDataSource *pageContentDataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation WeatherPagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    PageContentDataSource *dataSource = [[PageContentDataSource alloc] init];
    if ([dataSource count] == 0) {
        UIViewController *voidViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"void_view_controller"];
        [self addChildViewController:voidViewController];
        [self.view addSubview:voidViewController.view];
        [voidViewController didMoveToParentViewController:self];
    } else {
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"page_view_controller"];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.pageContentDataSource = [[PageContentDataSource alloc] init];
        [self.pageContentDataSource setStoryboard:self.storyboard];
        [self.pageViewController setDataSource:self.pageContentDataSource];
    
        WeatherViewController *weatherViewController = [self.pageContentDataSource viewControllerAtIndex:0];
        NSArray *controllers = @[weatherViewController];
        [self.pageViewController setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
