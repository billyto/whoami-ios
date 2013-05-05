//
//  VGIntroViewController.m
//  whoiam
//
//  Created by Billy Tobon on 4/27/13.
//  Licensed under the MIT License.
//

#import "VGIntroViewController.h"
#import "AFJSONRequestOperation.h"
#import "VGShowsViewController.h"
#import "VGAppDelegate.h"

@interface VGIntroViewController ()

@end

@implementation VGIntroViewController
@synthesize showlist;


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
    self.showlist =[[NSMutableArray alloc] init];
    [self fetchShows];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segue_show"])
    {
        
        VGShowsViewController *showsVC = (VGShowsViewController *)segue.destinationViewController;
        [showsVC setShowlist:self.showlist];

    }

}


- (void) fetchShows
{

//    Sample Shows from TMS  (Show Name - series_id)
//    Game of Thrones - 8553063
//    30 Rock - 185203
//    Simpsons - 183872
//    Walking Dead - 8282918
//    The IT Crowd - 299837
//    Dr Who - 370422
//    Family Guy - 184483
//    Person of Intrest - 8680539
//    Grimm - 8677098
//    sopranos - 184487
    
    //TODO: Get the following array based on a criteria, like what's on or favorite shows.
    NSArray *series_id = @[@"185044", @"8553063", @"185203", @"183872", @"8282918", @"299837", @"370422", @"184483", @"8680539", @"8677098", @"184487"];
   
    [series_id enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *series_id =obj;
        NSString *stringShow = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/series/%@?imageSize=Sm&api_key=%@",series_id,TMS_API_KEY];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringShow]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                NSDictionary *jsonDict = (NSDictionary *) JSON;
                                                                                                
                                                                                                [self.showlist addObject:jsonDict];
                                                                                                NSString *showName =[jsonDict objectForKey:@"title"];
                                                                                                NSLog(@"show: %@",showName);
                                                                                                
                                                                                                
                                                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                                                        NSError *error, id JSON) {
                                                                                                NSLog(@"Request Failure Because %@",[error userInfo]);
                                                                                            }
                                             ];
        
        [operation start];

    }];

}

- (IBAction)pickShow:(id)sender {
    
}

- (IBAction)record:(id)sender {
}
@end
