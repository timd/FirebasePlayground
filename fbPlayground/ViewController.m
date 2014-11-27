//
//  ViewController.m
//  fbPlayground
//
//  Created by Tim Duckett on 27/11/14.
//  Copyright (c) 2014 Tim Duckett. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>

@interface ViewController ()
@property (nonatomic, strong) Firebase *rootReference;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *topSpaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomSpaceLabel;
@end

// Your Firebase URL
static NSString * const firebaseURL = @"<your Firebase URL";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Hide the two labels initially
    self.topSpaceLabel.alpha = 0.0f;
    self.bottomSpaceLabel.alpha = 0.0f;
    
    // Setup Firebase and connect to your instance
    self.rootReference = [[Firebase alloc] initWithUrl:firebaseURL];
    
    // Create a listener that reacts to 'Child Added' events when received
    // The data received from Firebase is enclosed in the FDataSnapshot object
    [self.rootReference observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {

        // Check if the snapshot includes an 'actor' key
        if (snapshot.value[@"actor"]) {
            
            // If it does, extract the value from the 'actor' key
            NSString *actor = snapshot.value[@"actor"];
            
            __block UIView *viewToFlash;
            __block UILabel *labelToFadeIn;
            
            // Decide which view to flash
            if ([actor isEqualToString:@"top"]) {
                viewToFlash = self.bottomView;
                labelToFadeIn = self.bottomSpaceLabel;
            } else {
                viewToFlash = self.topView;
                labelToFadeIn = self.topSpaceLabel;
            }

            UIColor *currentColor = viewToFlash.backgroundColor;

            // Flash the views
            [UIView animateWithDuration:0.15f animations:^{
                [viewToFlash setBackgroundColor:[UIColor whiteColor]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15f animations:^{
                    [viewToFlash setBackgroundColor:currentColor];
                }];
            }];
            
            // Fade the labels
            [UIView animateWithDuration:0.5f animations:^{
                
                labelToFadeIn.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    labelToFadeIn.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    //
                }];
                
            }];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSendToBottom:(id)sender {
    
    // React to a tap on the top button
    
    // Create a dictionary of keys and values to send to Firebase
    NSDictionary *dict = @{@"actor" : @"top",
                           @"value" : @"didTapSendToBottom"};
    
    // Update the main node on Firebase by adding a new child value
    [[self.rootReference childByAutoId] setValue:dict];
}

- (IBAction)didTapSendToTop:(id)sender {

    // React to a tap on the top button
    
    // Create a dictionary of keys and values to send to Firebase
    NSDictionary *dict = @{@"actor" : @"bottom",
                           @"value" : @"didTapSendToTop"};

    // Update the main node on Firebase by adding a new child value
    [[self.rootReference childByAutoId] setValue:dict];
    
}

@end
