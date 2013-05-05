//
//  VGIntroViewController.h
//  whoiam
//
//  Created by Billy Tobon on 4/27/13.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>

@interface VGIntroViewController : UIViewController{}

@property (nonatomic, strong) NSMutableArray *showlist;

- (IBAction)pickShow:(id)sender;
- (IBAction)record:(id)sender;

@end
