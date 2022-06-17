# Project 1 - *Flixster*

**Flixster** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [ ] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [ ] Customize the UI.
- [ ] Run your app on a real device.

The following **additional** features are implemented:

- [x] Autolayout constraints allow various sized iPhones to display correctly.  
- [x] Embedded each synopsis in a scroll view to allow for easier reading.  
- [x] Displayed the average rating of each movie.
- [x] Added a search bar to the collection view.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):
1. I want to do programmatic segues for the detailed view of each movie.  
2. I want to programmatically control the CollectionView rather than through the Storyboard since it was very difficult to understand what was causing display issues.  
3. I want to finish figuring out how to center the activity indicator on the home page.  

## Video Walkthrough
Here's a walkthrough of implemented user stories:

[GIF Walkthrough Link](https://recordit.co/anGmPmj36B)
GIF created with [RecordIt](https://recordit.co/).

## Notes

Describe any challenges encountered while building the app.
- Tab bar item images would not set. This was because I was setting the 'Selected Image' instead of the 'Image' category which I did not notice.  
- Thought the tab bar was not showing up when it was, but it was transparent.  
- Getting text to size such that it all shows up and resizes so it can all be read, both titles and synopses.  
- Getting collection view to show multiple rows.  
- Imageview would not set autolayout constraints. Ended up just being buggy and I needed to delete and re-add it.  

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2022] [Chaytan C. Inman]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

