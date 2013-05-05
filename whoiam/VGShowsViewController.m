//
//  VGShowsViewController.m
//  whoiam
//
//  Created by Billy Tobon on 4/27/13.
//  Licensed under the MIT License.
//

#import "VGShowsViewController.h"
#import "VGCastViewController.h"
#import "AFNetworking.h"
#import "VGAppDelegate.h"

@interface VGShowsViewController ()

@property (nonatomic, assign) NSDictionary *selectedShow;

@end

@implementation VGShowsViewController
@synthesize showlist;
@synthesize selectedShow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Select a Show";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.showlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_show";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *showDict =[self.showlist objectAtIndex:indexPath.row];
    cell.textLabel.text = [showDict objectForKey:@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *imageURL = [NSString stringWithFormat:@"http://developer.tmsimg.com/%@?api_key=%@",[[showDict objectForKey:@"preferredImage"] objectForKey:@"uri"],TMS_API_KEY];
    NSLog(@"IMAGES %@", imageURL);
    NSURL *url = [[NSURL alloc] initWithString:imageURL];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"70-tv"]];

    return cell;
}


#pragma mark - Table view delegate

// We might not need this method after all
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//     self.selectedShow = [self.showlist objectAtIndex:indexPath.row];
//     [self performSegueWithIdentifier:@"segue_cast" sender:self];
//}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"segue_cast"])
    {
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        self.selectedShow = [self.showlist objectAtIndex:ip.row];
        VGCastViewController *castVC = (VGCastViewController *)segue.destinationViewController;
        
        NSString *tms_is = [self.selectedShow objectForKey:@"tmsId"];
        NSString *series_id = [self.selectedShow objectForKey:@"seriesId"];
        
        NSMutableDictionary *charade =[NSMutableDictionary dictionaryWithDictionary:@{@"series_id":series_id,@"tms_id":tms_is}];
        
        [castVC setCastList:[self.selectedShow objectForKey:@"cast"]];
        [castVC setCharadeDict:charade];
        
    }


}





@end
