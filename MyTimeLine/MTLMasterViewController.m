//
//  MTLMasterViewController.m
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 21/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import "MTLMasterViewController.h"
#import "MTLDetailViewController.h"

@interface MTLMasterViewController () {
    NSMutableArray *_objects;
    UIRefreshControl *refresh;
}
@end

@implementation MTLMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)getTimeLine {
    NSLog(@"%@",self.twitterAccount);
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSMutableDictionary *parameters =
    [[NSMutableDictionary alloc] init];
    [parameters setObject:@"40" forKey:@"count"];
    [parameters setObject:@"1" forKey:@"include_entities"];
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];
    postRequest.account = self.twitterAccount;
    NSLog(@"%@",postRequest.account);
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        if (error){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se ha podido establecer la conexión con el servidor compruebe si esta conectado a internet" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: nil];
            [message show];
            [self dismiss];
        }else{
            if (responseData) {
                if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                    NSError *jsonError;
                    NSDictionary *timelineData =
                    [NSJSONSerialization
                     JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                    if (timelineData) {
                        NSLog(@"Timeline Response: %@\n", timelineData);
                    }else {
                        // Our JSON deserialization went awry
                        NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                    }
                }else {
                    // The server did not respond ... were we rate-limited?
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d",urlResponse.statusCode] message:@"No se ha podido establecer la conexión con el servidor compruebe si esta conectado a internet" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: nil];
                    [message show];
                    [self dismiss];
                    NSLog(@"The response status code is %d",urlResponse.statusCode);
                }
            }
            self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            if (self.dataSource.count != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tweetTableView reloadData];
                    [refresh endRefreshing];
                    [self dismiss];
                });
            }else{
                
            }

        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showWithStatus];
    [self getTimeLine];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:.9f];
        self.navigationController.navigationBar.translucent = YES;
    }else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
    }
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(getTimeLine)forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView addSubview:refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identificador = @"customCell";
    MTLTweetCell *cell = (MTLTweetCell *)[tableView dequeueReusableCellWithIdentifier:identificador];
    if (cell == nil)
    {
        cell = [[MTLTweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    }
    NSDictionary *tweet = _dataSource[[indexPath row]];
    NSString *imageURL = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
    NSString *nombre = [[tweet objectForKey:@"user"] objectForKey:@"name"];
    NSString *nick = [[tweet objectForKey:@"user"] objectForKey:@"screen_name"];
    NSString *followers = [[tweet objectForKey:@"user"] objectForKey:@"followers_count"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *imagen = [[UIImage alloc] initWithData:data];
    NSLog(@"%@",nombre);
    cell.profileImg.image = imagen;
    cell.profileImg.layer.cornerRadius = imagen.size.width / 1.6;
    cell.profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    cell.profileImg.layer.borderWidth=2.3;
    cell.profileImg.layer.masksToBounds = YES;
    cell.nickLabel.text = [NSString stringWithFormat:@"@%@", nick];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", nombre];
    cell.tweetLabel.text = tweet[@"text"];
    cell.followersLabel.text = [NSString stringWithFormat:@"%@", followers];
    NSString *retweet = [tweet objectForKey:@"retweet_count"];
    int rt = [retweet intValue];
    NSLog(@"%d",rt);
    if(rt>0){
        cell.rtImg.hidden=false;
        cell.rtLabel.text = [NSString stringWithFormat:@"%@", retweet];
        cell.rtLabel.hidden = false;
    }
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (void)showWithStatus {
	[SVProgressHUD showWithStatus:@"Cargando TimeLine"];
}
- (void)dismiss {
	[SVProgressHUD dismiss];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mostrarTweet"]) {
        NSInteger row = [[self tweetTableView].indexPathForSelectedRow row];
        NSDictionary *tweet = [self.dataSource objectAtIndex:row];
        MTLDetailViewController *detalles = segue.destinationViewController;
        detalles.tweet=tweet;
    }
}

- (IBAction)postMessage:(id)sender {
    SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
        if(composeVC)
        {
            
            // assume everything validates
            BOOL success = YES;
            /*SLServiceTypeTwitter *cuenta = [SLServiceTypeTwitter init];
            cuenta.account = self.twitterAccount;*/
            
#pragma warning I should probably de-conditionalize this
#if 0
            if(sObject.type == SLServiceTypeTwitter)
            {
                success = [composeVC setInitialText: @"NSChat could have a drawing where people try to guess how many names Silly has used over the years. It could be like trying to count jellybeans in a glass vase."];
                if(success == NO)
                {
                    [self displayErrorAlert: @"this error hits because Twitter has 160 characters limit"];
                }
            }
#endif
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled){
                    NSLog(@"Cancelled");
                }else{
                    [self showWithStatus];
                    NSLog(@"Post");
                    [self getTimeLine];
                }
                [composeVC dismissViewControllerAnimated:YES completion:Nil];
            };
            composeVC.completionHandler =myBlock;
            if(success)
            {
                [self presentViewController: composeVC animated: YES completion: nil];
            }
        }
}

- (void)displayErrorAlert: (NSString *)alertMessage
{
    // suprise, I don't have any delegate methods defined :-)
    UIAlertView * anAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message: alertMessage delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil];
        NSLog(@"%@", alertMessage);
    [anAlert show];
}
@end
