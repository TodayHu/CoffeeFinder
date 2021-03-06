//
//  InterfaceController.m
//  CoffeeFinder WatchKit Extension
//
//  Created by David Olesch on 11/25/14.
//  Copyright (c) 2014 David Olesch. All rights reserved.
//

#import "InterfaceController.h"
#import "CoffeeFinder.h"

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *headerLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *locationDescriptionLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceMap *locationMap;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *locateNearbyCoffeeButton;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        NSLog(@"%@ initWithContext", self);
        [self.locationDescriptionLabel setText:@""];
        [self.locationMap setHidden:YES];
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    //[self locateNearbyCoffee];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}

- (void)locateNearbyCoffee
{
    [self.locationDescriptionLabel setText:@"Loading.."];
    [self.locationMap setHidden:YES];
    [self.headerLabel setHidden:YES];
    [self.locationMap removeAllAnnotations];
    [self.locateNearbyCoffeeButton setEnabled:NO];
    [CoffeeFinder findCoffeeNear:CLLocationCoordinate2DMake(userLatitude, userLongitude) withCompletionBlock:^(MKMapItem *coffeeItem) {
        [self.locationDescriptionLabel setText:coffeeItem.name];
        [self.locateNearbyCoffeeButton setEnabled:YES];
        [self.locationMap setHidden:NO];
        [self.locationMap addAnnotation:coffeeItem.placemark.location.coordinate withPinColor:WKInterfaceMapPinColorRed];
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coffeeItem.placemark.location.coordinate, MKCoordinateSpanMake(0.005f, 0.005f));
        [self.locationMap setCoordinateRegion:region];
    }];
}

- (IBAction)touchedLocateNearbyCoffee {
    [self locateNearbyCoffee];
}

@end



