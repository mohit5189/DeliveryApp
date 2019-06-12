# Delivery App

To run this project, please follow following steps:

1. Open terminal and go to project folder where .podfile is stored.
2. Run pod install / pod update.
3. Once command run successfully, go to project folder and open .xcworkspace file in xcode.

# Requirements

- XCode 10.2
- MAC 10.14

# Supported iOS Version

- iOS 11.0 +

# Language 

- Swift 5.0


# App Version

- 1.0

# Unit Testing Frameworks

- Used Nimble/Quick for unit testing purpose
- XCUITest not covered in this sample.

# Design Patterns

1. MVVM
2. Adapter design pattern

Please check below for low level diagram:

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/Architecture.png)

1. View / View Controller - This layer is responsible to handle UI operation based on callback from viewModel class.
2. ViewModel - This layer contains all business logic and list of models.
3. DataManager - This class is responsible to fetch data either from server OR from DB based on several scenario defined above in App Flow section.
4. APIManager - On this layer we have kept logic to parse individual response. This layer is designed by keeping in mind that all checks on server response and parsing will be implemented here. DataManager will either receive response OR error based on logic defined on this layer.
5. DBManager - Responsible to handle data from DB.
6. HTTPClient - Responsible to make HTTP api call.

# Caching

1. App using CoreData with Sqlite to make cache of JSON response.
2. For Image caching, App is using third party library SDWebImage.
3. App has implemented pull to refresh functionality in following way:
  - If user make pull to refresh class and either internet is off OR server return error, previous rendered list will remain unchanged in that case.
  - If server return error but cache found, then app fetches cached data and display initial page in TableView.
  - If server return proper response, app display data and call for DB cache.
4. App is not deliting any data, In case if updated data coming from server, then app update local DB based on ID.

# Assumptions        
1. App support Localization, but for this version app contains only english text.     
2. App support iPhone device in Portrait mode only. 
3.  Supported mobile platforms are iOS (11.x, 12.x)        
4.  Device support - iPhone 5s, iPhone 6 Series, iPhone SE, iPhone 7 Series, iPhone 8 Series, iPhone X Series    

# Crashlytics

App has implemented crashlytics using Febric. Here is the steps for crashlytics setup.
1. Create Organization on Febric, it can be named as your company.
2. Then simply update app configurations as per your organization. Please follow https://fabric.io/kits/ios/crashlytics/install for the same.

# SwiftLint
1. Install the SwiftLint is by downloading SwiftLint.pkg from latest GitHub release and running - https://github.com/realm/SwiftLint/releases
2. Or by HomeBrew by running "brew install swiftlint" command
3. Add the run script in the xcode (target -> Build pahse -> run script -> add the script) if not added
4. If need to change the rules of swiftlint, goto root folder of the project
5. Open the .swiftlint.yml file and modify the rules based on the requirement

  # Note
  App is not deleting data from cache, instead its updating data on pull to refresh operation  

# CocoaPods Used

- Quick
- Nimble
- MBProgressHud
- SDWebImage
- ReachabilitySwift
- Febric
- Crashlytics

# Network Calling

App used native NSURLSession for making http call.

# App Data Flow

This app perform network api call for destinations listing, if network call is successful, it display the list and save in DB to show it later in offline mode. In case if user come next time and make network call for any specific page, app try to fetch data from network and if not found then try to find same page data in local DB. So sequence will be like:

1. App make network call
2. if network call succeed then app display data and cache the JSON in DB
3. if network call failes, app try to fetch data from local DB and if found then display in list else it show error to user.

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/flow.png)


# Displaying Map

1. Once user select any addess, app shows annotation to selected address and in backgroung start fetching current location of user. 

2. In case if current location found and their is a route between current location and selected address, App display that route to the user.

# Pagination Handling

For pagination logic, App will assume more pages till the time it don't get empty list of response from server. In case of offline mode, it will always try for next page ( this is to make sure that if app comes online then it should return response).

# ScreenShots

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/destinationList.png)
![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/map.png)

# TODO / Improvements

-  UI test cases
- Better handling of data caching for deletion of records
