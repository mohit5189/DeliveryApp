# Delivery App

To run this project, please follow following steps:

1. Open terminal and go to project folder where .podfile is stored.
2. Run pod install / pod update.
3. Once command run successfully, go to project folder and open .xcworkspace file in xcode.

# Requirements

- XCode 10.2
- MAC 10.14

# Supported iOS version

- iOS 11+

# Unit Testing frameworks

- Used Nimble/Quick for unit testing purpose
- XCUITest not covered in this sample.

# Design patterns

1. MVVM
2. Adapter design pattern

# Caching

1. App using CoreData with Sqlite to make cache of JSON response.
2. For Image caching, App is using third party library SDWebImage.
3. App has implemented pull to refresh functionality in following way:
  - If user make pull to refresh class and either internet is off OR server return error, previous rendered list will remain unchanged in that case.
  - If server return error but cache found, then app fetches cached data and display initial page in TableView.
  - If server return proper response, app display data and call for DB cache.

  # Note
  App is not deleting data from cache, instead its updating data on pull to refresh operation  

# Third Party framwworks

1. Quick
2. Nimble
3. MBProgressHud
4. SDWebImage

# Network calling

App used NSURLSession for making http call.

# Delivery List Api Flow

This app perform network api call for destinations listing, if network call is successful, it display the list and save in DB to show it later in offline mode. In case if user come next time and make network call for any specific page, app try to fetch data from network and if not found then try to find same page data in local DB. So sequence will be like:

1. App make network call
2. if network call succeed then app display data and cache the JSON in DB
3. if network call failes, app try to fetch data from local DB and if found then display in list else it show error to user.

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/flow.png)

# Classes Architecture 

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/Architecture.png)

1. View / View Controller - This layer is responsible to handle UI operation based on callback from viewModel class.
2. ViewModel - This layer contains all business logic and list of models.
3. DataManager - This class is responsible to fetch data either from server OR from DB based on several scenario defined above in App Flow section.
4. APIManager - On this layer we have kept logic to parse individual response. This layer is designed by keeping in mind that all checks on server response and parsing will be implemented here. DataManager will either receive response OR error based on logic defined on this layer.
5. DBManager - Responsible to handle data from DB.
6. HTTPClient - Responsible to make HTTP api call.


# Displaying map

1. Once user select any addess, app shows annotation to selected address and in backgroung start fetching current location of user. 

2. In case if current location found and their is a route between current location and selected address, App display that route to the user.

# Pagination Handling

For pagination logic, App will assume more pages till the time it don't get empty list of response from server. In case of offline mode, it will always try for next page ( this is to make sure that if app comes online then it should return response).

# TODO / Improvements

-  UI test cases
-  SwiftLint
-  Crashlytics

# ScreenShots

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/destinationList.png)
![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/map.png)

