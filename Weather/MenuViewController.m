//
//  MenuViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *ids;

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ids = @[@"weather_now", @"your_localization", @"find_city"];
    self.titles = @[@"Weather now", @"Your localization", @"Find city"];
    self.tableView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ids count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.ids objectAtIndex:indexPath.row] forIndexPath:indexPath];
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass: [SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:dvc];
            [self.revealViewController setFrontViewController:navigationController animated:YES];
        };
        
    }
}

@end
