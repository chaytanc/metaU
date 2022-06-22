//
//  CollectionViewController.m
//  Pods
//
//  Created by Chaytan Inman on 6/16/22.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface MovieCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *moviesArrayProp;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) UIRefreshControl* refreshControl;

@end

@implementation MovieCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;

    // Refresh for the data in the tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    self.refreshControl = refreshControl;
    
    [self fetchMovies: FALSE];
}

- (void) fetchMovies: (BOOL) isRefresh {
    // Callback for getting movie rating data from themoviedb.org and populating tableview w this data
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=aaef6e1a9cec569a711a7e7dddd52fca"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Added dispatch call
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                // Show loading error
                [self presentNetworkErrorAlert];
            }
            else {
                [self loadData: data];
                
                // Init VC to have all data showing before any searches
                self.filteredData = self.moviesArrayProp;
            }
            if(isRefresh) {
                // Tell the refreshControl to stop spinning
                 [self.refreshControl endRefreshing];
            }
        });
       }];
    [task resume];
}


- (void) loadData: (NSData*) data {
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSArray *moviesArray = dataDictionary[@"results"];
    for (id movie in moviesArray) {
        NSLog(@"---FILM: %@", movie); // Log each movie
    }
    self.moviesArrayProp = moviesArray;
    [self.collectionView reloadData];
}

- (void) presentNetworkErrorAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                   message:@"Movies failed to load. Check your connection."
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

//MARK: Coll View
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    
    NSString *urlString = self.filteredData[indexPath.row][@"poster_path"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullURL = [baseURLString stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:fullURL];
    [cell.collImageView setImageWithURL:url];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected cell number: %ld", (long)indexPath.row);
}

//MARK: Refresh

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchMovies: TRUE];
}

//MARK: Search Bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // Dynamically update our filteredData prop with what the user changes in the search bar
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            // This makes it so we search through titles
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.moviesArrayProp filteredArrayUsingPredicate:predicate];
    }
    
    else {
        self.filteredData = self.moviesArrayProp;
    }
    
    [self.collectionView reloadData];
 
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.collectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
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
