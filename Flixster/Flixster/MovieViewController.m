//
//  MovieViewController.m
//  Flixster
//
//  Created by Chaytan Inman on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"


@interface MovieViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *moviesArrayProp;
@end

NSString *CellIdentifier = @"movieCell";


@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Refresh for the data in the tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

    
    // Tableview setup
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 170;
//    self.tableView.estimatedRowHeight = 250;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Start the activity indicator
    [self.activityIndicator startAnimating];

    // Callback for getting movie rating data from themoviedb.org and populating tableview w this data
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=aaef6e1a9cec569a711a7e7dddd52fca"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               // Show loading error
               [self networkError];
           }
           else {

               [self loadData: data];
               [self.activityIndicator stopAnimating];
           }
       }];

    [task resume];
}

- (void) loadData: (NSData*) data {
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSArray *moviesArray = dataDictionary[@"results"];
    self.moviesArrayProp = moviesArray;
    [self.tableView reloadData];
}

- (void) networkError {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                   message:@"Movies failed to load. Check your connection."
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Title and description
    cell.titleLabel.text = self.moviesArrayProp[indexPath.row][@"title"];

    cell.synopsisLabel.text = self.moviesArrayProp[indexPath.row][@"overview"];
    cell.synopsisLabel.numberOfLines = 0;
//    cell.synopsisLabel.adjustsFontSizeToFitWidth = YES;
//    cell.synopsisLabel.minimumScaleFactor = 0.4;
    
    // Popularity of movie
    NSString *pop = [NSString stringWithFormat:@"%@", self.moviesArrayProp[indexPath.row][@"vote_average"]];
    if( pop.length > 4) {
        pop = [pop substringWithRange:NSMakeRange(0, 4)];
    }
    NSString *popTitle = @"Popularity: ";
    pop = [popTitle stringByAppendingString:pop];
    cell.popLabel.text = pop;
    
    // Set the movie image
    NSString *urlString = self.moviesArrayProp[indexPath.row][@"poster_path"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullURL = [baseURLString stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:fullURL];
    [cell.posterImageView setImageWithURL:url];

    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moviesArrayProp.count;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=aaef6e1a9cec569a711a7e7dddd52fca"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
           // ... Use the new data to update the data source ...
            if(error != nil) {
                [refreshControl endRefreshing];
                [self networkError];
            }
            else {
                [self loadData:data];
                // Reload the tableView now that there is new data
                [self.tableView reloadData];
            }


           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
