//
//  VGCharadeViewController.m
//  whoiam
//
//  Created by Billy Tobon on 4/27/13.
//  Licensed under the MIT License.
//

#import "VGCharadeViewController.h"
#import <FPPicker/FPPicker.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
#import "AmazonClientManager.h"
#import "AFHTTPClient.h"
#import <Parse/Parse.h>
#import "VGAppDelegate.h"

@interface VGCharadeViewController ()

@end

@implementation VGCharadeViewController
@synthesize submitButton;
@synthesize recordButton;
@synthesize charadeDict;
@synthesize filename;

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
    self.title = @"Charade";
    [self.submitButton setHidden:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) recordAndPlay:(id)sender
{

    [self startCameraControllerFromViewController:self usingDelegate:self];

}

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    // 1 - Validattions
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:NO];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        NSLog(@"Video path %@",moviePath);
        NSData *videoData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        [self saveVideo:videoData];
        
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


-(void) saveVideo:(NSData *)videoData
{
    
    NSString *prefixString = @"videotest";
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@.mov", prefixString, guid];
    NSLog(@"uniqueFileName: '%@'", uniqueFileName);
    
    S3PutObjectRequest *request = [[S3PutObjectRequest alloc] initWithKey:uniqueFileName inBucket:@"hviggle"];
    request.data = videoData;
    request.cannedACL = [S3CannedACL publicRead];
  
    S3PutObjectResponse *response = [[AmazonClientManager s3] putObject:request];
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
    }
    else
    {
        NSLog(@"video updloaded %@", response.description );
        NSString *videoURL =[NSString stringWithFormat:@"s3://s3.amazonaws.com/%@/%@",S3_BUCKET_NAME,uniqueFileName];
        NSString *encodedUrl =[NSString stringWithFormat:@"s3://s3.amazonaws.com/%@/encoded/%@",S3_BUCKET_NAME,uniqueFileName];
        
        encodedUrl = [encodedUrl stringByReplacingOccurrencesOfString:@".mov" withString:@".mp4"];
        [self encodeVideo:videoURL andName:encodedUrl];
    }

}


-(void) encodeVideo:(NSString*)videoURL andName:(NSString *)name
{
    NSURL *url = [NSURL URLWithString:@"https://app.zencoder.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Zencoder-Api-Key" value:ZENCODER_API_KEY];

    NSString *iconURL =[NSString stringWithFormat:@"s3://s3.amazonaws.com/%@/icon.png",S3_BUCKET_NAME];
    NSDictionary *waterDict = @{@"url":iconURL, @"height":[NSNumber numberWithInt:44], @"width":[NSNumber numberWithInt:44], @"x":@"20%", @"y":@"10%"};
    NSDictionary *outDict = @{@"url":name , @"format": @"mp4",@"video_codec": @"h264", @"public":[NSNumber numberWithBool:YES], @"watermarks":@[waterDict]};
    
    NSDictionary *params = @{@"input":videoURL, @"outputs":@[outDict] };
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient postPath:@"/api/v2/jobs" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        
        self.filename = name;
        [self.submitButton setHidden:NO];
        [self.recordButton setHidden:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesomesauce!" message:@"Video Successfully saved and encoded." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ouch" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
}




- (IBAction)SubmitAction:(id)sender {
    
    PFObject *testObject = [PFObject objectWithClassName:@"ContestObject"];
    [testObject setValuesForKeysWithDictionary:self.charadeDict];
    NSString *video_url =[self.filename stringByReplacingOccurrencesOfString:@"s3:" withString:@"https:"];
    
    [testObject setObject:video_url forKey:@"video_url"];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Ouch!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not cool." message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            NSLog(@"complete!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We are ready" message:@"Tell your friends to guess your charade!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
    
}
@end
