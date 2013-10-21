/*
 *  MMSAppDelegate.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2013 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>

#import "MMSAppDelegate.h"
#import "MMSViewController.h"
#import "MMSCrashUtils.h"

@interface MMSAppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MMSAppDelegate

+ (void)initialize
{
    if ([self class] == [MMSAppDelegate class]) {
        // TODO: set appropriate application key provided by Yandex Metrica/
        [YMMCounter startWithAPIKey:1111];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MMSViewController alloc] initWithNibName:@"MMSViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    //  uncomment this code to test crash handling on application launch.
//    [MMSCrashUtils randomCrash];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLocationUpdates];
    });
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self shutdownLocationUpdates];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startLocationUpdates];
}

#pragma mark - Working with Location Updates

- (void)startLocationUpdates
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)shutdownLocationUpdates
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

#pragma mark - CLLocationManagerDelegate Implementation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [YMMCounter setLocation:newLocation];
}

@end
