# AppHub Starter Project

This is an example project which uses AppHub to instantly push updates to users.
For more information on AppHub and its features, visit [the website](https://apphub.io) and
[the docs](https://apphub.io/docs).

In this project, we prompt the user with a `UIAlertView` when an update becomes available. The user can choose to
"Update" the app instantly, or press "Cancel", in which case the app will be updated upon restart.

All AppHub specific code can be found in
[AppDelegate.m](https://github.com/AppHubPlatform/AppHubStarterProject/blob/master/iOS/AppHubStarterProject/AppDelegate.m).

## Getting Started

To get started, clone or fork this repo and run:

    npm install

 in the root directory.

Then, open `iOS/AppHubStarterProject.xcodeproj` and set your Application ID as specified from the
AppHub dashboard:

    [AppHub setApplicationID:@"APPLICATION ID"];

Once you have set the Application ID, hit run in Xcode.

Take a look at the options inside the `sourceURLForBridge:` method of [AppDelegate.m](https://github.com/AppHubPlatform/AppHubStarterProject/blob/master/iOS/AppHubStarterProject/AppDelegate.m#L54).
You should use "Option 1" while developing, and switch to "Option 2" when deploying to beta and production users.

## Creating AppHub Builds

To update your app, just build a standard `.ipa` file and upload the new build with the AppHub dashboard.

We recommend using [gym](https://github.com/fastlane/gym) to create an `.ipa` file from your project,
but you can also [build an ipa with Xcode](http://stackoverflow.com/questions/25970741/how-to-create-ipa-in-xcode-6).

