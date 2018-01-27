
# react-native-eegmuselib

## General info

**@todo** answer https://github.com/NeuroTechX/eeg-101/issues/12#issuecomment-360995067 once stable

This is a minimalistic cross-plateform (both iOS & android) wrapper over the
Muse Headband EEG's ios & android libraries for react-native.

While it probably will work with 2014 muse headbands, it is only tested for the
2016 Headbands.

We've choosen to wrap the original libraries instead of reverse-engineering the
muse's Bluetooth LE protocol as we expect the bluetooth protocol to be more
prone to change than the libraries in the future.


## Current status

- [x] iOS
- [ ] android
- [ ] API doc


## Compatibility

**iOS:**

- Check full compatibility information on [this link](/nuks/podspec-libmuse). **@todo** check link is working

**Android:**

- Incompatible at the moment.

**Muse 2016 x 2014**

- Muse 2014 is untested.
- Paired muse 2016 appears in the available list even when powered off. See the [API doc](http://ios.choosemuse.com/protocol_i_x_n_muse_listener-p.html).


## Getting started

`$ npm install react-native-eegmuselib --save`


### Mostly automatic installation

You must install Cocoapods and create an empty Podfile in your ios folder. Once
it's done, you can type the following command:

`$ react-native link react-native-eegmuselib`


### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-eegmuselib` and add `RNEegMuseLib.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNEegMuseLib.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<


#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNEegMuseLibPackage;` to the imports at the top of the file
  - Add `new RNEegMuseLibPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-eegmuselib'
  	project(':react-native-eegmuselib').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-eegmuselib/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-eegmuselib')
  	```

#### Windows

[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNEegMuseLib.sln` in `node_modules/react-native-eegmuselib/windows/RNEegMuseLib.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Eeg.Muse.Lib.RNEegMuseLib;` to the usings at the top of the file
  - Add `new RNEegMuseLibPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage

```javascript
import RNEegMuseLib from 'react-native-eegmuselib';

// TODO: What to do with the module?
RNEegMuseLib;
```


## Development

The muse-related dependencies are handled using Gradle for android & Cocoapod
for iOS.

You may want to have a look at the tutorial we've used for building this react-
native libraries:

- [part 1 - bootstrap & android](https://medium.com/gbox-crew-blog/making-libraries-for-react-native-14a8f5006697)
- [part 2 - ios](https://medium.com/gbox-crew-blog/making-libraries-for-react-native-eaca35b5b1d7)
- [part 3 - publishing](https://medium.com/@carlyeah/making-f7ce79cd19a) 


### Test

To test without publishing, `npm link` can be used in place of both
`npm publish` and `npm install`. Check the [doc](https://docs.npmjs.com/cli/link).

1. In this library's directory:
  
  `$ npm link`

2. In the test project:
  
  `$ npm link react-native-eegmuselib`


### Publish

Publishing is done through npm via:

`$ npm publish`

