# libmuse

libmuse is a library for interfacing with Muse headbands, including finding
paired Muses, connecting to them, reading their state, and receiving packets
for raw EEG data and all other values. You can use it in your own applications,
subject to the terms of our license.

The library consists of two parts: a core in C++ and a platform-specific
interface in whatever language your platform writes its interfaces in: Java for
Android, Objective-C for iOS.

Visit http://developer.choosemuse.com for additional information.

Have questions? Visit [Muse Forum](http://forum.choosemuse.com/)


**Lib Version:**

- Muse.framework 6.0.8


## Compatibility

Check [Ramon Arguello's pod](https://cocoapods.org/pods/libmuse) for an older
version of the lib with higher compatibilty range.

**Muse Headband compatibility:**

- [x] Muse Headband 2014 **(untested)**
- [x] Muse Headband 2016

**iOS version compatibility:**

- [ ] 10.2 *(uncompatible framework build)*
- [x] 10.3+

**Hardware compatibility [(source)](https://en.wikipedia.org/wiki/IOS_10):**

- iPhone
  * [ ] iPhone 4 *(no BLE support)*
  * [ ] iPhone 4S *(BLE support - but framework compiled for uncompatible iOS version)*
  * [x] iPhone 5
  * [x] iPhone 5C
  * [x] iPhone 5S
  * [x] iPhone 6
  * [x] iPhone 6 Plus
  * [x] iPhone 6S
  * [x] iPhone 6S Plus
  * [x] iPhone SE
  * [x] iPhone 7
  * [x] iPhone 7 Plus
- iPod Touch
  * [ ] iPod Touch (5th generation) *(BLE support - but framework compiled for uncompatible iOS version)*
  * [x] iPod Touch (6th generation)
- iPad
  * [ ] iPad (2th generation) *(no BLE support)*
  * [ ] iPad (3th generation) *(BLE support - but framework compiled for uncompatible iOS version)*
  * [x] iPad (4th generation)
  * [x] iPad Air
  * [x] iPad Air 2
  * [x] iPad (2017)
  * [x] iPad Mini 2
  * [x] iPad Mini 3
  * [x] iPad Mini 4
  * [x] iPad Pro

**Language compatibility:**

- [ ] Swift *(unknown/untested - most likely compatible)*
- [x] Objective C


## iOS

### Quick start

### Including it in your own application

Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
and add the following line to your project's Podfile:

```
pod "libmuse", :git => "https://github.com/nuks/podspec-libmuse.git"
```

Add a `#import "Muse.h"` line to your source where appropriate. If you're using
Swift, make sure you add it to your bridging header. You should be able to
reference classes like `IXNMuse` and `IXNMuseManager` now. Consult the API
reference rooted at `doc/index.html` for usage information.
