//
//  CollectionViewController.m
//  Pods
//
//  Created by Chaytan Inman on 6/16/22.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *moviesArrayProp;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation CollectionViewController

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
               
               // Init VC to have all data showing before any searches
               self.filteredData = self.moviesArrayProp;
           }
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

- (void) networkError {
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
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    
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
                [self.collectionView reloadData];
            }


           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

//MARK: Search Bar

//- (UICollectionReusableView *)supplementaryViewForElementKind:(NSString *)elementKind
//                                                  atIndexPath:(NSIndexPath *)indexPath {
//    if (elementKind == UICollectionElementKindSectionHeader) {
//
//        UICollectionReusableView *headerView =  [self.collectionView dequeueReusableSupplementaryViewOfKind:(NSString *)UICollectionElementKindSectionHeader withReuseIdentifier: @"CollectionViewHeader" forIndexPath:(NSIndexPath *)indexPath];
//        return headerView;
//
//    }
//
//    return [[UICollectionReusableView alloc] init];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = [self.collectionView dequeueReusableCellWithIdentifier:@"TableCell"
//                                                                 forIndexPath:indexPath];
//    cell.textLabel.text = self.filteredData[indexPath.row];
//
//    return cell;
//}

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
