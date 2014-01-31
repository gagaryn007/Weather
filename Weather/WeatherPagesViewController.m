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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;

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
        
        self.trashButton.enabled = NO;
    } else {
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"page_view_controller"];
//        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.pageContentDataSource = [[PageContentDataSource alloc] init];
        [self.pageContentDataSource setStoryboard:self.storyboard];
        [self.pageViewController setDataSource:self.pageContentDataSource];
    
        WeatherViewController *weatherViewController = [self.pageContentDataSource viewControllerAtIndex:0];
        NSArray *controllers = @[weatherViewController];
        [self.pageViewController setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        
        self.trashButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didClickTrashButton:(id)sender {
    WeatherViewController *weather = (WeatherViewController *)[self.pageViewController.viewControllers lastObject];
    
    NSString *message = [[NSString alloc] initWithFormat:@"Do you want to delete %@?", weather.city.cityName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        WeatherViewController *weatherViewController = (WeatherViewController *) [self.pageViewController.viewControllers lastObject];

        [self.pageContentDataSource removeCity:weatherViewController.city];
        
        UIViewController *viewController = [self.pageContentDataSource pageViewController:self.pageViewController viewControllerAfterViewController:weatherViewController];
        if (viewController == nil) {
            viewController = [self.pageContentDataSource pageViewController:self.pageViewController viewControllerBeforeViewController:weatherViewController];
        }
        
        if (viewController == nil) {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"void_view_controller"];
            self.trashButton.enabled = NO;
        }
        
        [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [weatherViewController.view removeFromSuperview];
        [weatherViewController removeFromParentViewController];
    }
}

@end
