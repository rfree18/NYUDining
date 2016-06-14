# NYUDining
NYUDining for iPhone makes finding all of the dining halls on campus simple and easy. Never again will you need to dig through CampusDish to find dining hours, location, and other details! Simply download NYUDining and find everything in a matter of seconds. Check back soon for updates!

**Support**: To report any bugs, issues, or feedback, please use the issues page and add a new issue. You can also email me directly at RFreemanApps@gmail.com and I will do my best to get back to you ASAP. Thanks :)

# Current Release Notes
Version 1.3.0 is a very minor update that improves stability.

# Upcoming Release Notes
Version 1.4.0 is completely rewritten, making the app much faster and more efficient! This update is expected to be released soon and will likely be the last version before 2.0.0.

# A Note about Parse
Parse, the service that hosts and provides the data for the NYUDining app, recently announced that they are beginning to wind down its services, taking the entire database offline early next year. In anticipation of this, I have already completed the migration of the app data from Parse to a MongoDB instance. This change did not affect the existing version of the app in any way, but it is the first step in migrating from Parse. The current version of the app is still utiziling Parse's services to handle all API reqests. Version 1.2.2 and newer will instead ping a custom server, thereby removing Parse entirely.
# End of Support for Old Versions
With Parse shutting down, older versions prior to 1.3.0 will cease to function at any given moment. As a result, all users must update to the latest version ASAP for uninturrupted access to information.
