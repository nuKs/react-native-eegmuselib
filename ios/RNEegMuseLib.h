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
 * For javascript communication, we have to rely on events instead of callback.
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

@interface RNEegMuseLib : NSObject <RCTBridgeModule>
//RCTEventEmitter

/*
- (id) init;

@property (nonatomic) NSMutableDictionary* _allMuses;
@property (nonatomic) NSMutableDictionary* _connectedMuses;
*/

/* Global Listeners */

// listenBluetoothStatus
// unlistenBluetoothStatus

/**
 * Scan for the muses using bluetooth.
 **/
//- (void) listenChangedMuselist;
//- (void) unlistenChangedMuselist;

// listenReceivedLog
// unlistenReceivedLog

/* Instance-level Listeners */

// - (void) listenChangedStatusOfMuse:(NSString*) macAdress;
// - (void) unlistenChangedStatusOfMuse:(NSString*) macAdress;

// listenReceivedDataOnMuse
// unlistenReceivedDataOnMuse

// listenReceivedArtefactOnMuse
// unlistenReceivedArtefactOnMuse

// listenReceivedErrorOnMuse
// unlistenReceivedErrorOnMuse

@end
