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


@property (nonatomic, strong) NSArray *moviesArrayProp;
@end

NSString *CellIdentifier = @"movieCell";


@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Tableview setup
    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 250;
    self.tableView.rowHeight = 250;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;


    // Callback for getting movie rating data from themoviedb.org and populating tableview w this data
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=aaef6e1a9cec569a711a7e7dddd52fca"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.

               NSArray *moviesArray = dataDictionary[@"results"];
               for (id movie in moviesArray) {
                   NSLog(@"%@", movie); // Log each movie
               }
               self.moviesArrayProp = moviesArray;
               [self.tableView reloadData];
           }
       }];

    [task resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.titleLabel.text = self.moviesArrayProp[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.moviesArrayProp[indexPath.row][@"overview"];
//    int pop = ;
    NSString *pop = [NSString stringWithFormat:@"%@", self.moviesArrayProp[indexPath.row][@"popularity"]];
    if( pop.length > 6) {
        pop = [pop substringWithRange:NSMakeRange(0, 5)];
    }
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
