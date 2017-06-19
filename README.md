[![Vapor FCM](https://cloud.githubusercontent.com/assets/1230922/24428437/c16ec982-140e-11e7-8ab9-ab764e573ae1.png)](http://github.com/mdab121/vapor-fcm)

[![Build Status](https://travis-ci.org/mdab121/vapor-fcm.svg?branch=master)](https://travis-ci.org/mdab121/vapor-fcm)
[![codebeat badge](https://codebeat.co/badges/2c81440f-8467-453d-9df7-a9352ddc6e5d)](https://codebeat.co/projects/github-com-mdab121-vapor-fcm-master)
![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20OS%20X-blue.svg)
![Package Managers](https://img.shields.io/badge/package%20managers-SwiftPM-yellow.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
[![Twitter Follow](https://img.shields.io/twitter/follow/espadrine.svg?style=social&label=Follow)](https://twitter.com/mdab121)

> Simple Vapor framework for sending Firebase Cloud Messages.

### :question: Why?
Do you want to write your awesome server in Swift using [Vapor](http://github.com/vapor/vapor)? At some point, you'll probably need to send Push Notifications to Android as well 😉

### ✅ Features
- [x] Full message Payload support: badges and sounds for iOS
- [x] Response parsing, instant send response feedback
- [x] Custom data payload support

### Vapor Versions

- [x] Use Vapor-FCM version `1.x` for Vapor `1.x`
- [x] Use Vapor-FCM version `2.x` for Vapor `2.x`

### 💻 Installation

#### Swift Package Manager

```swift
.Package(url: "https://github.com/mdab121/vapor-fcm.git", majorVersion: 2, minor: 0)
```


### 🔢 Usage

#### Simple Example

Sending a simple FCM Message is really simple. Just create a `Firebase` object that will deliver your messages.

```swift
let firebase = try Firebase(drop: droplet, keyPath: "/path/to/your/key")
```

Create a `Message`, and send it!

```swift
let payload = Payload(text: "Hello VaporFCM!")
let message = Message(payload: payload)
let token = DeviceToken("this_is_a_device_token")
let response = try firebase.send(message: message, to: token)
if response.success {
	// Handle success
} else {
	// Handle error
}
```
