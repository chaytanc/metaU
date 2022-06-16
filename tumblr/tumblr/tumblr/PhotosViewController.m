//
//  PhotosViewController.m
//  tumblr
//
//  Created by Chaytan Inman on 6/16/22.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *PhotosTableView;
@property (strong, nonatomic) NSDictionary *posts;
@property (strong, nonatomic) NSMutableArray *validPhotos;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PhotosTableView.dataSource = self;
    self.PhotosTableView.delegate = self;
    self.PhotosTableView.rowHeight = 415;

    
    // Request from Tumblr API
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
            
            // Get the dictionary from the response key
            NSDictionary *responseDictionary = dataDictionary[@"response"];
            // Store the returned array of dictionaries in our posts property
            
            self.posts = responseDictionary[@"posts"];
            self.validPhotos = [NSMutableArray new];
            
            // Get valid photos
            for(id post in self.posts) {
                NSArray *photos = post[@"photos"];
                if(photos) {
                    NSDictionary *photo = photos[0];
                    [self.validPhotos addObject:photo];
                }
            }
            
            [self.PhotosTableView reloadData];
            
        }
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

- (NSInteger)tableView:(UITableView *)PhotosTableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)PhotosTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [PhotosTableView dequeueReusableCellWithIdentifier:@"PhotoCellID" forIndexPath:indexPath];

    // Get valid photo
    NSDictionary *photo = self.validPhotos[indexPath.row];

    // 2. Get the original size dictionary from the photo
    NSDictionary *originalSize =  photo[@"original_size"];

    // 3. Get the url string from the original size dictionary
    NSString *urlString = originalSize[@"url"];

    // 4. Create a URL using the urlString
    NSURL *url = [NSURL URLWithString:urlString];
    
    [cell.PhotoImageView setImageWithURL:url];

    return cell;
}


@end
