# NYUDining
NYUDining for iPhone makes finding all of the dining halls on campus simple and easy. Never again will you need to dig through CampusDish to find dining hours, location, and other details! Simply download NYUDining and find everything in a matter of seconds. Check back soon for updates!

**Note**: Special holiday hours are now available! Holidays will be added as they become available without any update necessary.

**Support**: To report any bugs, issues, or feedback, please use the issues page and add a new issue. You can also email me directly at RFreemanApps@gmail.com and I will do my best to get back to you ASAP. Thanks :)

# Current Release Notes
Version 1.2.1 is a very minor update that fixes a small issue with the navigation bar color changing.

# Upcoming Release Notes
Version 1.2.2 is a minor update that redirects API requests to AWS from Parse. The user should not notice any major changes, although other features/enhancements may be added prior to release.

# A Note about Parse
Parse, the service that hosts and provides the data for the NYUDining app, recently announced that they are beginning to wind down its services, taking the entire database offline early next year. In anticipation of this, I have already completed the migration of the app data from Parse to a MongoDB instance. This change did not affect the existing version of the app in any way, but it is the first step in migrating from Parse. The current version of the app is still utiziling Parse's services to handle all API reqests. Version 1.2.2 and newer will instead ping a custom server, thereby removing Parse entirely.
# End of Support for Old Versions
Once version 1.2.2 is launched, all older versions will temporarily continue to function. Early next year, all earlier versions will no longer function and may even crash. All users must update as soon as possible in order to ensure that the app continues to function as normal. There will be no support for users on older versions.
