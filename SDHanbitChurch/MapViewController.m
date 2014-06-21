//
//  MapViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 6/3/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapControl;
- (IBAction)directionButton:(id)sender;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    _mapControl.showsUserLocation = YES;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.827608, -117.162542);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 30000, 30000);
    [_mapControl setRegion:region animated:NO];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"한빛교회";
    [_mapControl addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)directionButton:(id)sender
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.827608, -117.162542);
    
    NSDictionary *address = @{(NSString *)kABPersonAddressStreetKey: @"4717 Cardin St.",
                              (NSString *)kABPersonAddressCityKey: @"San Diego",
                              (NSString *)kABPersonAddressStateKey: @"CA",
                              (NSString *)kABPersonAddressZIPKey: @"92111",
                              (NSString *)kABPersonAddressCountryCodeKey: @"US"};
    
    MKPlacemark *place = [[MKPlacemark alloc]initWithCoordinate:coordinate addressDictionary:address];
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
    
    [mapItem openInMapsWithLaunchOptions:nil];
}

@end
