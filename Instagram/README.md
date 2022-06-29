# Project 3 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption

The following **optional** features are implemented:

- [ ] Run your app on your phone and use the camera to take the photo
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling
- [x/-] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [ ] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen
- [x] User can like a post and see number of likes for each post in the post details screen
- [ ] Style the login page to look like the real Instagram login page
- [ ] Style the feed to look like the real Instagram feed
- [ ] Implement a custom camera view

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!
- [x] Custom UIView popup programmatically displayed on the login screen to sign up users
- [x] Autolayout constraints for all rotations and iPhone sizes
- [x] Partially bolded string for showing username and caption in same label (NSAttributedString)
- [x] Display total likes of all posts on user profile

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Subclassing, protocols, code reuse
2. Database structure and scalability for keeping track of likes and comments on posts

## Video Walkthrough

Here's a walkthrough of implemented user stories:

[Video Walkthrough](https://recordit.co/w2uIUmyO3m.gif)

GIF created with [RecordIt](https://recordit.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://github.com/MatthewYork/DateTools)
- [Parse](https://www.back4app.com/parse)

## Notes
Implementing a programmatic popup view to sign up users was definitely a challenge. It involved programmatic constraints, understanding when the frame was initialized and where I could set those constraints, learning how to create components like UITextFields and stackviews programatically, setting up the delegate for the text fields in the popup so that the keyboard could be dismissed, and many more small, frequent challenges.

## License

    Copyright [2022] [Chaytan Inman]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
