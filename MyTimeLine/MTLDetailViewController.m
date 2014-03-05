//
//  MTLDetailViewController.m
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 21/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import "MTLDetailViewController.h"

@interface MTLDetailViewController ()
- (void)configureView;
@end

@implementation MTLDetailViewController

#pragma mark - Managing the detail item

- (bool)ContieneImagen{
    int ban=0;
    NSDictionary *datos= self.tweet;
    NSArray *media =[[datos objectForKey:@"entities"]objectForKey:@"media"];
    NSDictionary *mediaDic = [media objectAtIndex:0];
    NSArray * llaves;
    llaves = [mediaDic allKeys];
    for (int i=0; i<[llaves count]; i++) {
        if([llaves[i]isEqual:@"media_url"]){
            ban++;
            break;
        }
    }
    if (ban!=0){
        return true;
    }else{
        return false;
    }
}

- (bool)ContieneContadores{
    if ([self contieneFV] || [self contieneRT]) {
        return true;
    }else{
        return false;
    }
}

-(BOOL) contieneRT{
    NSDictionary *datos= self.tweet;
    NSString *retweet = [datos objectForKey:@"retweet_count"];
    int rt = [retweet intValue];
    if(rt>0){
        return true;
    }else{
        return false;
    }
}

-(BOOL) contieneFV{
    NSDictionary *datos= self.tweet;
    NSString *favorite = [datos objectForKey:@"favorite_count"];
    int fv = [favorite intValue];
    if(fv>0){
        return true;
    }else{
        return false;
    }
}

- (void)configureView
{
    if (self.tweet) {
        NSDictionary *datos = self.tweet;
        NSString *name = [[datos objectForKey:@"user"] objectForKey:@"name"];
        self.navBar.title= name;
        _tweetTableView.delegate=self;
        _tweetTableView.dataSource=self;
        [self.tweetTableView reloadData];
        self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
        self.tweetTableView.backgroundColor = [UIColor clearColor];
   }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self ContieneImagen] && [self ContieneContadores]) {
        return 3;
    }else{
        if ([self ContieneContadores] || [self ContieneImagen]) {
            return 2;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *datos = self.tweet;
    switch (indexPath.row) {
        case 0:{
            NSString *identificador = @"profileInfo";
            MTLTweetDetails *cell = (MTLTweetDetails *)[tableView dequeueReusableCellWithIdentifier:identificador];
            if (cell == nil)
            {
                cell = [[MTLTweetDetails alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileInfo"];
            }
            cell.tweetLabel.text=datos[@"text"];
            NSString *name = [[datos objectForKey:@"user"] objectForKey:@"name"];
            cell.nameLabel.text=name;
            NSString *nick = [[datos objectForKey:@"user"] objectForKey:@"screen_name"];
            cell.nickLabel.text=[NSString stringWithFormat:@"@%@", nick];
            NSString *imageURL = [[datos objectForKey:@"user"] objectForKey:@"profile_image_url"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            cell.profileImg.image = img;
            cell.profileImg.layer.cornerRadius = img.size.width / 4;
            cell.profileImg.layer.borderColor = [UIColor grayColor].CGColor;
            cell.profileImg.layer.borderWidth=2.3;
            cell.profileImg.layer.masksToBounds=YES;
            UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
            UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
            cellBackgroundView.image = background;
            cell.backgroundView = cellBackgroundView;
            NSDate *date = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
            NSDate *fecha = [df dateFromString:[datos objectForKey:@"created_at"]];
            NSTimeInterval secondsBetween = [date timeIntervalSinceDate:fecha];
            int segundos = secondsBetween;
            if (segundos >= 60) {
                //es mayor a un minuto
                if (segundos >= 3600) {
                    //es mayor a una hora
                    if (segundos >= 86400) {
                        //Diferencia por día
                        int dias = segundos/86400;
                        cell.dateLabel.text = [NSString stringWithFormat:@"Hace %dd", dias];
                    }else{
                        //Se pasan por horas
                        int horas = segundos/3600;
                        cell.dateLabel.text = [NSString stringWithFormat:@"Hace %dh", horas];
                    }
                }else{
                    //menor a una hora
                    int min = segundos/60;
                    cell.dateLabel.text = [NSString stringWithFormat:@"Hace %dm", min];
                }
            }else{
                //menor a un minutoint
                cell.dateLabel.text = [NSString stringWithFormat:@"Hace %ds", segundos];
            }
            return cell;
        }
            break;
        case 1:{
            if([self ContieneContadores]){
                NSString *identificador1 = @"contadores";
                MTLCounterDetail *cell = (MTLCounterDetail *)[tableView dequeueReusableCellWithIdentifier:identificador1];
                if (cell == nil)
                {
                    cell = [[MTLCounterDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador1];
                }
                NSString *retweet = [datos objectForKey:@"retweet_count"];
                int rt = [retweet intValue];
                NSString *favorite = [datos objectForKey:@"favorite_count"];
                int fv = [favorite intValue];
                if(rt!=0){
                    cell.rtLabel.text=[NSString stringWithFormat:@"%@", retweet];
                }else{
                    cell.rtLabel.hidden=true;
                    cell.staticRT.hidden=true;
                }
                if(fv!=0){
                    cell.favLabel.text=[NSString stringWithFormat:@"%@", favorite];
                }else{
                    cell.favLabel.hidden=true;
                    cell.staticFav.hidden=true;
                }
                UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
                UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
                cellBackgroundView.image = background;
                cell.backgroundView = cellBackgroundView;
                return cell;
            }else{
                NSString *identificador1 = @"imgTweet";
                MTLImgContainer *cell = (MTLImgContainer *)[tableView dequeueReusableCellWithIdentifier:identificador1];
                if (cell == nil)
                {
                    cell = [[MTLImgContainer alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador1];
                }
                NSArray *media =[[datos objectForKey:@"entities"]objectForKey:@"media"];
                NSDictionary *mediaDic = [media objectAtIndex:0];
                NSString *imageURL = [mediaDic objectForKey:@"media_url"];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                UIImage *img = [[UIImage alloc] initWithData:data];
                cell.imgTweet.image=img;
                UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
                UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
                cellBackgroundView.image = background;
                cell.backgroundView = cellBackgroundView;
                return cell;
            }
           
        }
            break;
        case 2:{
            NSString *identificador1 = @"imgTweet";
            MTLImgContainer *cell = (MTLImgContainer *)[tableView dequeueReusableCellWithIdentifier:identificador1];
            if (cell == nil)
            {
                cell = [[MTLImgContainer alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador1];
            }
            NSArray *media =[[datos objectForKey:@"entities"]objectForKey:@"media"];
            NSDictionary *mediaDic = [media objectAtIndex:0];
            NSString *imageURL = [mediaDic objectForKey:@"media_url"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            cell.imgTweet.image=img;
            UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
            UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
            cellBackgroundView.image = background;
            cell.backgroundView = cellBackgroundView;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int altura;
    switch (indexPath.row) {
        case 1:
            if ([self ContieneContadores]) {
                altura=30;
            }else{
                altura = 320;
            }
            break;
        case 2:
            altura = 320;
            break;
        default:
            altura= self.tweetTableView.rowHeight;
            break;
    }
    return altura;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    //[spinner release];
    [self configureView];
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tweetTableView] numberOfRowsInSection:0];
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

@end
