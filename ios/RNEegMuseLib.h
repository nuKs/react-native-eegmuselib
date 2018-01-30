#import <Foundation/Foundation.h>

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#endif

/**
 * @note
 * We use a master class / flat hierarchy instead of a regular object-oriented
 * structure for the reason mentioned below. The flat hierarchy will be fold in
 * a more convenient one via JS.
 *
 * http://facebook.github.io/react-native/docs/native-modules-ios.html#ios-calendar-module-example
 * > The return type of bridge methods is always void. React Native bridge is
 * > asynchronous, so the only way to pass a result to JavaScript is by using
 * > callbacks or emitting events (see below).
 *
 * For javascript communication, we rely on events for multiple occurence and
 * on promises for single occurence.
 *
 * http://facebook.github.io/react-native/docs/native-modules-ios.html#callbacks
 * > A native module should invoke its callback exactly once.
 *
 * This class is thus architectured with the same constraint a client-server
 * would have. Client is the JS code while server is the ObjC one.
 *
 * This api maps the native API as close as possible.
 *
 * @warning
 * Each new javascript instance of this class will reinstantiate new
 * CoreBluetooth instances, etc. For better performance, this class should only
 * be instanciated once in the javascript.
 **/

@interface RNEegMuseLib : RCTEventEmitter <RCTBridgeModule>

- (id) init;

// inherited from RCTEventEmitter
- (NSArray<NSString*>*) supportedEvents;
- (void) startObserving;
- (void) stopObserving;

// @property (nonatomic) NSMutableDictionary* _allMuses;
// @property (nonatomic) NSMutableDictionary* _connectedMuses;

/* Methods */

- (void) connectMuse: (NSString*) macAddress;

/* Global Listeners */

// subscribeBluetoothStatus
// unsubscribeBluetoothStatus


// Scan for the muses using bluetooth.
- (void) subscribeMuselistChanged;
- (void) unsubscribeMuselistChanged;
- (void) muselistWithResolver: (RCTPromiseResolveBlock)resolve
                 withRejecter: (RCTPromiseRejectBlock)reject;

// subscribeReceivedLog
// unsubscribeReceivedLog

/* Muse Listeners */

- (void) subscribeConnectionStateChangedForMuse: (NSString*)macAddress; // emit events
- (void) unsubscribeConnectionStateChangedForMuse: (NSString*)macAddress; // stop emitting events
- (void) connectionStateForMuse: (NSString*)macAddress
                   withResolver: (RCTPromiseResolveBlock)resolve
                   withRejecter: (RCTPromiseRejectBlock)reject; // return promise

// subscribeReceivedDataOnMuse
// unsubscribeReceivedDataOnMuse

// subscribeReceivedArtefactOnMuse
// unsubscribeReceivedArtefactOnMuse

// subscribeReceivedErrorOnMuse
// unsubscribeReceivedErrorOnMuse

@end


