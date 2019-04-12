# My Driver

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
An app that can be used to make people who needs a driver with a car find it easily.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Transportation
- **Mobile:** This app must be used on mobile as it uses your location and maps to help you find a driver.
- **Story:** Connects drivers with car with riders who needs a ride.
- **Market:** any person who needs a ride can use this app.
- **Habit:** This app can be used daily and even more than one time a day for transportation.
- **Scope:** This app will be used to pair first people with drivers as a first phase. Its second phase will be using it also to pair people who needs any type of transportation encluding busses and limosines.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login and signup
* User can log out
* User can stay logged in
* User can see his location
* User can ask for driver
* User can cancel his driver request
* Driver can accept requests

**Optional Nice-to-have Stories**

* User can chat with driver
* User can have drivers phone number
* User can pay driver
* User can see where the driver that accepted his request is

### 2. Screen Archetypes

* Login/Signup
   * If this is the first time to use the app user can signup for my driver
   * user can login to app
* Riders view controller
   * user can see where he is
   * user can ask for driver
   * user can cancel request for driver
* Requests view controller
   * Driver can see all requests 
   * Driver can see how far is the rider from him
   * Driver can check location of rider
* Driver view controller
   * Driver can see where the rider is 
   * Driver can accept ride
   * Driver can cancel ride
   * Driver can see a path to the rider

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* Login/signup rider
   * Riders view controller
* Login/signup Driver
   * Requests view controller
* Requests view controller
   * Driver view controller
* Driver view controller
   * Requests view controller
## Wireframes
<img src="https://i.imgur.com/A64cgcp.jpg" width=800>

## Schema 

### Models
 | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | Username      | String   | unique id user|
   |password |String | user password|
   |type | bool | driver or rider
   | distance | float | distance from driver to rider|
   |Mylocation | clloction | the location of Rider|
   |Driver location | cllocation | the location of driver|
### Networking
   - login/signup
      - (Create/user) create new user
         ```swift
            let user = PFUser()
            user.username = userNameTextfield.text
            user.password = passwordTextfield.text
            user["isdriver"] = `switch`.isOn
            user.signUpInBackground { (succeed, error) in
                if let error = error{
                    if let errorString = error as? String{
                        self.displayallert(title: "error signing up ", message: errorString)
                    }
                }
            }
         ```
      - (get/user) check if username and password are right and if this is a driver or a rider
   - Riders view controller
      - (Create/request) create new request for driver
      - (Delete/request) cancel request
      - (Create/location) 
   - Requests view controller
      - (Read/GET) requests reading from parse
   - Drivers view controller
      - (Read/GET) read riders location
      - (create/location)create drivers location

