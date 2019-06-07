# DestinationsSample

To run this project, please follow following steps:

1. Open terminal and go to project folder where .podfile is stored.
2. Run pod install.
3. Once command run successfully, go to project folder and open workspace file in xcode.

# Unit Testing frameworks

- Used Nimble/Quick for unit testing purpose
- Test cases are written with BDD (Behaviour driven development) approach.
- XCUITest not covered in this sample.

# Design patterns

1. MVVM
2. Adapter design pattern

# Caching

App manages caching of response using core data.

# Third Party framwworks

1. Quick
2. Nimble
3. MBProgressHud
4. SDWebImage

# Network calling

App used NSURLSession for making http call.

# App Flow

This app perform network api call for destinations listing, if network call is successful, it display the list and save in DB to show it later in offline mode. In case if user come next time and make network call for any specific page, app try to fetch data from network and if not found then try to find same page data in local DB. So sequence will be like:

1. App make network call
2. if network call succeed then app display data and cache the JSON in DB
3. if network call failes, app try to fetch data from local DB and if found then display in list else it show error to user.

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/flow.png)


# Displaying map

1. Once user select any addess, app shows annotation to selected address and in backgroung start fetching current location of user. 

2. In case if current location found and their is a route between current location and selected address, App display that route to the user.

# Assumption

For pagination logic, App will assume more pages till the time it don't get empty list of response from server. In case of offline mode, it will always try for next page ( this is to make sure that if app comes online then it should return response).

# ScreenShots

![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/destinationList.png)
![ScreenShot](https://github.com/mohit5189/DestinationsSample/blob/master/ScreenShots/map.png)

