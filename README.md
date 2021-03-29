# GimmeAHand

<img src="./icon.png" alt="GimmeAHand Logo" width="200"/>

Project for Mobile &amp; IoT Computing Services

# Instructions

This app is written in Swift 5 and Xcode 12.4.

1. ~~Install `Cocoapods`: `sudo gem install cocoapods`.~~
2. ~~Run `pod install` in root folder. (If failed, run `rvm use ruby-2.3.0` first).~~
3. Open `GimmeAHand.xcworkspace`.
4. `Cmd + R` to run.
5. To modify the default launching storyboard, in Xcode, click `GimmeAHand.xcodeproj -> General` and change in  `Deployment Info -> Main Interface` and `Info.plist -> Application Scene Manifest -> Scene Configuration -> Application Session Role -> Item 0 -> Storyboard Name`.

# Project Structure

* This app is constructed in MVC (model-view-controller) architecture.
* The files are organizend and grouped by **modules**, i.e. Homepage, Order, Profile and Login/Register.
* The view components are mostly in `*.storyboard` files, along with other reusable views written in code for fast prototyping and work division.
* The controller components are in `*ViewController.swift` files.
* The model components are yet to be added.

A folder-level app strcture is described in the following tree (only folders are displayed).

```
.
├── GimmeAHand
│   ├── Common                      # common reusable view controllers
│   ├── Constants                   # constants used in across the app
│   ├── CustomizedViews             # common reusable views
│   ├── DataHelper                  # helpers to save miscellaneous data
│   ├── Extensions                  # extensions for UIView, UIViewController, etc.
│   ├── Homepage                    # all view controllers related to homepage module
│   ├── LoginRegister               # all view controllers related to login and register module
│   ├── Order                       # all view controllers related to order module
│   ├── Profile                     # all view controllers related to profile module
├── Pods                            # third party libraries managed by CocoaPods
```

# Authors

* [Kuixi Song](https://kuixisong.one)
* Chengyongping Lu
* Linxiao Cui
* Yifan Huang
* Yue Xu
