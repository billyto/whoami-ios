//
//  VGCharadeViewController.h
//  whoiam
//
//  Created by Billy Tobon on 4/27/13.
//  Licensed under the MIT License.
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface VGCharadeViewController : UIViewController


-(IBAction)recordAndPlay:(id)sender;
-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;


@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) NSMutableDictionary *charadeDict;
@property (nonatomic, strong) NSString *filename;

- (IBAction)SubmitAction:(id)sender;

@end
