//
//  HomeViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "UIViewController+PresentError.h"
#import "HomePicCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray* posts;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    // Do any additional setup after loading the view.
    // Refresh for the data in the tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:refreshControl atIndex:0];
}

- (void) viewWillAppear:(BOOL)animated {
    [self fetchPosts];
}

- (void) fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    // If we want to get more than 20, query based on date and store latest date or post taht was fetched
//    [query whereKey:@"likesCount" greaterThan:@100];
    //XXX todo when loading more than 20, have to store latest shown
//    [query orderByDescending:@"createdAt" whereKey:"createdAt" greaterThan:lastLoaded];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.feedTableView reloadData];
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchPosts];
    [refreshControl endRefreshing];
}

- (IBAction)didTapLogout:(id)sender {
    NSLog(@"Logout Tapped");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if(error != nil) {
            [self presentError:@"Logout Failed" message:@"Unable to logout user." error:error];
        }
        else {
            SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

            [sceneDelegate.window setRootViewController:loginViewController];

        }
    }];
}

// MARK: Tableview

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post *post = self.posts[indexPath.row];
    HomePicCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"homePicCell" forIndexPath:indexPath];
    // Passes tweet data to TweetCell
    cell.post = post;

//    [cell formatHeaderAndBody];
//    [cell formatFooter];
    [cell refreshData];
        
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

// MARK: Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    UINavigationController *navigationController = [segue destinationViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
//
//    if ([[segue identifier] isEqualToString:@"composeSegue"])
//    {
//
//
//        DetailsViewController *detailsController = (DetailsViewController*)navigationController.topViewController;
//        detailsController.tweet = self.arrayOfTweets[indexPath.row];
//    }
//    else if ([[segue identifier] isEqualToString:@"composeSegue"]) {
//        UINavigationController *navigationController = [segue destinationViewController];
//        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
//        // Tell composeController we can receive info about tweet composed
//        composeController.delegate = self;
//    }
}

@end
