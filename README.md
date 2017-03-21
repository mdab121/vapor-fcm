[![Swift FCM](https://cloud.githubusercontent.com/assets/1230922/23826163/ca1d09b6-0696-11e7-8912-a3950418fc36.png)](http://github.com/mdab121/swift-fcm)

[![Build Status](https://travis-ci.org/mdab121/swift-fcm.svg?branch=master)](https://travis-ci.org/mdab121/swift-fcm)
[![Latest Release](https://img.shields.io/github/release/mdab121/swift-fcm.svg)](https://github.com/mdab121/swift-fcm/releases/latest)
![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20OS%20X-blue.svg)
![Package Managers](https://img.shields.io/badge/package%20managers-SwiftPM-yellow.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
[![Twitter Follow](https://img.shields.io/twitter/follow/espadrine.svg?style=social&label=Follow)](https://twitter.com/mdab121)

> Simple framework for sending Firebase Cloud Messages.

### :question: Why?
Do you want to write your awesome server in Swift? At some point, you'll probably need to send Push Notifications to Android as well 😉

### ✅ Features
- [x] Full message Payload support: badges and sounds for iOS
- [x] Response parsing, instant send response feedback
- [x] Custom data payload support


### 💻 Installation

#### Swift Package Manager

```swift
.Package(url: "https://github.com/mdab121/swift-fcm.git", majorVersion: 0, minor: 2)
```


### 🔢 Usage

#### Simple Example

Sending a simple FCM Message is really simple. Just create a `Firebase` object that will deliver your messages.

```swift
let firebase = try Firebase(keyPath: "/path/to/your/key")
```

Create a `Message`, and send it!

```swift
let payload = Payload(message: "Hello SwfitFCM!")
let message = Message(payload: payload)
let token = DeviceToken("this_is_a_device_token")
try firebase.send(message: message, to: token) { response in
  // Check response.success to check if your message was delivered successfully
}
```
