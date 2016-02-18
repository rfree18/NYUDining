# NYUDining
NYUDining for iPhone makes finding all of the dining halls on campus simple and easy. Never again will you need to dig through CampusDish to find dining hours, location, and other details! Simply download NYUDining and find everything in a matter of seconds. Check back soon for updates!

**Note**: Special holiday hours are now available! Holidays will be added as they become available without any update necessary.

**Support**: To report any bugs, issues, or feedback, please use the issues page and add a new issue. You can also email me directly at RFreemanApps@gmail.com and I will do my best to get back to you ASAP. Thanks :)

# Current Release Notes
Version 1.2.1 is a very minor update that fixes a small issue with the navigation bar color changing.

# A Note about Parse
Parse, the service that hosts and provides the data for the NYUDining app, recently announced that they are beginning to wind down its services, taking the entire database offline early next year. In anticipation of this, I have already completed the migration of the app data from Parse to a MongoDB instance. This change did not affect the existing version of the app in any way, but it is the first step in migrating from Parse. However, the app still relies on Parse's servers for receiving API calls that the app sends. I am currently in the process of setting up an alternative service either on Heroku or AWS in order to fully complete the migration. This will require some small changes to the app, which are expected to be released in the next major version of NYUDining. 
# End of Support for Old Versions
Once the update that no longer pings Parse is launched, I will begin to wind down the Parse database. Shortly after the update is released, all prior app versions will lose support and users will be forced to update to the latest release. This is being done to both allow for users to experience all of the enhanced features and to prevent users from experiencing a crashing app once Parse is taken offline. Users who have push notifications enabled will be given ample notification time. Anyone who stays on an older version of the app will experience frequent crashing, lack of data, or possibly various other errors.
