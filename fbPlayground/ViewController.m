//
//  ViewController.m
//  fbPlayground
//
//  Created by Tim Duckett on 27/11/14.
//  Copyright (c) 2014 Citrix. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>

@interface ViewController ()
@property (nonatomic, strong) Firebase *rootReference;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup Firebase
    self.rootReference = [[Firebase alloc] initWithUrl:@"https://resplendent-torch-5621.firebaseio.com"];
    
    [self.rootReference observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {

        if (snapshot.value[@"actor"]) {
            
            NSString *actor = snapshot.value[@"actor"];
            
            __block UIView *viewToFlash;
            
            if ([actor isEqualToString:@"top"]) {
                viewToFlash = self.bottomView;
            } else {
                viewToFlash = self.topView;
            }

            UIColor *currentColor = viewToFlash.backgroundColor;

            // Flash the bottom
            [UIView animateWithDuration:0.15f animations:^{
                [viewToFlash setBackgroundColor:[UIColor whiteColor]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15f animations:^{
                    [viewToFlash setBackgroundColor:currentColor];
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
    NSLog(@"didTapSendToBottom");
    
    NSDictionary *dict = @{@"actor" : @"top",
                           @"value" : @"didTapSendToBottom"};
    
    [[self.rootReference childByAutoId] setValue:dict];
}

- (IBAction)didTapSendToTop:(id)sender {
    NSLog(@"didTapSendToTop");

    NSDictionary *dict = @{@"actor" : @"bottom",
                           @"value" : @"didTapSendToTop"};
    
    [[self.rootReference childByAutoId] setValue:dict];
}

@end
