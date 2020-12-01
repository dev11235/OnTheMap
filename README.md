# OnTheMap

OnTheMap is a kind of chek-in app with a map that shows information posted by other student of Udacity.

# Features

* **Login with Udacity account.** The app has a login view that accepts email and password strings from users, with a “Login” button.
* **Download student locations over the network.** The app downloads the 100 most recent locations posted by students.
* **Represent student locations.** The app displays downloaded student locations in a tabbed view with two tabs: a map with annotations and a table.
* **Post new student location.** Users can post their own information to the server. App performs forward geocoding of the text provided by users.

#Frameworks and External APIs

Student information is loaded from and posted to Fake Udacity API. JSON requests and responses are encoded and decoded using Codable Protocol.

# Installation

The app is not intended to use as a library, so clone, build and run normally using Xcode 11 and Swift 5 :-)
