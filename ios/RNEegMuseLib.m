#import <Muse/Muse.h>
#import <NSArray+F.h>
#import "RNEegMuseLib.h"

#if __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import <React/RCTLog.h>
#endif

@interface RNEegMuseLib () <IXNMuseListener, IXNMuseConnectionListener,
                            IXNMuseDataListener> // <CBCentralManagerDelegate>

@property IXNMuseManagerIos*  museManager;
// @property (weak, nonatomic) IXNMuse * muse;
// @property (nonatomic) NSMutableArray* logLines;
// @property (nonatomic) BOOL lastBlink;
// @property (nonatomic, strong) CBCentralManager * btManager;
// @property (atomic) BOOL btState;

@property (nonatomic) NSDictionary* muselist;
@end

@implementation RNEegMuseLib

// Singleton to solve crash
// see https://github.com/facebook/react-native/issues/15421
// 
// @todo
// clean the listener using stopObserving could fix this
// probably some memory leaks to fix.
+ (id) allocWithZone:(NSZone *)zone {
    static RNEegMuseLib *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        // Retrieve muse manager singleton
        self.museManager = [IXNMuseManagerIos sharedManager];
        
        // Subscribe to museListChanged
        [self.museManager setMuseListener:self];
        
        //
//        self.btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
//        self.btState = FALSE;
        
        RCTLogInfo(@"My super first Init :)");
    }
    
    return self;
}

// Use the main app thread.
- (dispatch_queue_t) methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString*>*) supportedEvents
{
    return @[@"muselistChanged", @"museConnectionStateChanged", @"museDataReceived"];
}


// - (void)receiveMuseArtifactPacket:(nonnull IXNMuseArtifactPacket *)packet muse:(nullable IXNMuse *)muse {
    
// }

// - (void)receiveMuseDataPacket:(nullable IXNMuseDataPacket *)packet muse:(nullable IXNMuse *)muse {
    
// }

// Export constants to javascript
- (NSDictionary *) constantsToExport
{
    return @{ @"FrameworkVersion": @"6.0.8" };
}

- (void) startObserving
{
    //    for (NSString *event in [self supportedEvents]) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self
    //                                                 selector:@selector(handleNotification:)
    //                                                     name:event
    //                                                   object:nil];
    //    }
}

- (void) stopObserving
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/* Methods */

- (IXNMuse*) _getMuse: (NSString*)macAddress
{
    NSArray* muses = [self.museManager getMuses];

    // Return object if found.
    for (IXNMuse* muse in muses) {
      if ([[muse getMacAddress] isEqualToString: macAddress]) {
        return muse;
      }
    }
    
    // Return nil if not found.
    return nil;
}

/* Global Listeners */

// Muse list
- (void) museListChanged // observer implemented from IXNMuseListener
{
    RCTLogInfo(@"Received: museListChanged");
    NSArray* muses = [self.museManager getMuses];
    
    // Regenerate muselist with new data
    NSDictionary* processedMuselist = [NSDictionary
        dictionaryWithObjects: [muses map:^NSDictionary*(IXNMuse *muse) {
            RCTLogInfo(@"Muse: %@ at %@", [muse getMacAddress], [muse getName]);
        	return @{
                 @"macAddress": [muse getMacAddress],
                 @"name": [muse getName]
        	};
    	}]
        forKeys: [muses map:^NSString*(IXNMuse *muse) {
        	return [muse getMacAddress];
    	}]
    ];
    
    // Update list property
    [self setMuselist: processedMuselist];
    
    // Send event to JS
    // @todo ? check there is JS observer using startObserver method ?
    [self sendEventWithName:@"muselistChanged" body:@{@"muselist": [self muselist]}];
    RCTLogInfo(@"Sent: muselistChanged");
}

RCT_EXPORT_METHOD(subscribeMuselistChanged)
{
    RCTLogInfo(@"Subscribe: muselistChanged");
    [self.museManager startListening];
    [self museListChanged];
}
RCT_EXPORT_METHOD(unsubscribeMuselistChanged)
{
    RCTLogInfo(@"Unsubscribe: muselistChanged");
    [self.museManager stopListening];
    [self museListChanged];
}
RCT_REMAP_METHOD(getMuselist,
                 muselistWithResolver: (RCTPromiseResolveBlock)resolve
                 withRejecter: (RCTPromiseRejectBlock)reject)
{
    NSDictionary* muselist = [self muselist];
    resolve(muselist);
}


// Muse connection state
RCT_EXPORT_METHOD(connectMuse: (NSString*)macAddress)
{
    // Get muse
    RCTLogInfo(@"Connect: muse (attempt)");
    IXNMuse* muse = [self _getMuse: macAddress];

    // If muse not found
    if (muse == nil) {
        // @todo throw error
    }
    // If muse found
    else {
        RCTLogInfo(@"Connect: muse");

        // @todo prevent multiple connection to the same muse
        // @todo rely on `subscribeMuseConnectionStateChanged` instead
        [muse registerConnectionListener: self];
        // [muse registerDataListener: self
        //       type: IXNMuseDataPacketTypeArtifacts];
        // [muse registerDataListener: self
        //       type: IXNMuseDataPacketTypeAlphaAbsolute];
        // [muse registerDataListener: self
        //       type: IXNMuseDataPacketTypeBetaAbsolute];
        // [muse registerDataListener: self
        //       type: IXNMuseDataPacketTypeDeltaAbsolute];
        // [muse registerDataListener: self
        //       type: IXNMuseDataPacketTypeThetaAbsolute];
        [muse registerDataListener: self
              type: IXNMuseDataPacketTypeGammaAbsolute];
        // [muse registerDataListener: self
        //       type: IXNMuseDataPacketTypeEeg];

        // packet type: see http://ios.choosemuse.com/_i_x_n_muse_data_packet_type_8h.html#adc5312f54405294ac0fda06ba08b6ef5

        // Connect to the muse & launch a non-blocking execution loop in 
        // another thread that includes connection management.
        // @warning
        // must be called on the same thread that deliver notification (for now
        // as stated in the api doc).
        [muse runAsynchronously];
    }
}


- (void) receiveMuseConnectionPacket:(nonnull IXNMuseConnectionPacket *)packet
                                muse:(nullable IXNMuse *)muse // observer implemented from IXNMuseConnectionListener
{
    RCTLogInfo(@"Received: museConnectionPacket");

    // Parse state
    NSString *state;
    switch (packet.currentConnectionState) {
        case IXNConnectionStateDisconnected:
            state = @"disconnected";
            break;
        case IXNConnectionStateConnected:
            state = @"connected";
            break;
        case IXNConnectionStateConnecting:
            state = @"connecting";
            break;
        case IXNConnectionStateNeedsUpdate: state = @"needs update"; break;
        case IXNConnectionStateUnknown: state = @"unknown"; break;
        default: NSAssert(NO, @"impossible connection state received");
    }

    // Sent event to JS
    [self sendEventWithName:@"museConnectionStateChanged" body:@{
        @"macAddress": [muse getMacAddress],
        @"connectionState": state
    }];
    RCTLogInfo(@"Sent: museConnectionStateChanged");
}

RCT_REMAP_METHOD(subscribeMuseConnectionStateChanged,
                 subscribeConnectionStateChangedForMuse:(NSString*)macAddress)
{
    // [self subscribeConnectionStateChangedForMuse: macAddress];
}
RCT_REMAP_METHOD(unsubscribeMuseConnectionStateChanged,
                 unsubscribeConnectionStateChangedForMuse:(NSString*)macAddress)
{
    // [self unsubscribeConnectionStateChangedForMuse: macAddress];
}
RCT_REMAP_METHOD(getMuseConnectionState,
                 connectionStateForMuse: (NSString*)macAddress
                 withResolver: (RCTPromiseResolveBlock)resolve
                 withRejecter: (RCTPromiseRejectBlock)reject)
{
    /*
    NXIMuse muse = [[self muselist] getByKey: macAddress];
    NSString* museConnectionState = [muse getConnectionState];
    resolve(museConnectionState);
    */
}

//    NSArray *events = ...
//    if (events) {
//        resolve(events);
//    } else {
//        NSError *error = ...
//        reject(@"no_events", @"There were no events", error);
//    }

//
//RCT_EXPORT_METHOD(addEvent: (NSString *)name location: (NSString *)location)
//{
//   RCTL_ogInfo(@"Pretending to create an event %@ at %@", name, location);
//}


// Muse data stream
- (void) receiveMuseDataPacket:(IXNMuseDataPacket *)packet
                          muse:(IXNMuse *)muse
{
    // RCTLogInfo(@"Received: museDataPacketReceived");

    // Convert type to string
    NSString *type;
    switch (packet.packetType) {
        case IXNMuseDataPacketTypeAlphaAbsolute:
            type = @"alphaAbsolute";
            break;
        case IXNMuseDataPacketTypeBetaAbsolute:
            type = @"betaAbsolute";
            break;
        case IXNMuseDataPacketTypeDeltaAbsolute:
            type = @"deltaAbsolute";
            break;
        case IXNMuseDataPacketTypeThetaAbsolute:
            type = @"thetaAbsolute";
            break;
        case IXNMuseDataPacketTypeGammaAbsolute:
            type = @"gammaAbsolute";
            break;
        case IXNMuseDataPacketTypeEeg:
            type = @"rawEeg";
            break;
        default: 
            type = @"unknown";
            RCTLogError(@"Unknown packet type");
            //NSAssert(NO, @"impossible connection state received");
            return;
            break;
    }

    // Send event to JS
    // see http://ios.choosemuse.com/_i_x_n_muse_data_packet_type_8h.html#adc5312f54405294ac0fda06ba08b6ef5
    [self sendEventWithName:@"museDataReceived" body:@{
        @"type": type,
        @"timestamp": [NSString stringWithFormat:@"%lld", packet.timestamp], //int64
        @"leftEar": (isnan([(NSNumber*)packet.values[IXNEegEEG1] doubleValue])) ? @(0) : packet.values[IXNEegEEG1],
        @"leftForehead": (isnan([(NSNumber*)packet.values[IXNEegEEG2] doubleValue])) ? @(0) : packet.values[IXNEegEEG2],
        @"rightForehead": (isnan([(NSNumber*)packet.values[IXNEegEEG3] doubleValue])) ? @(0) : packet.values[IXNEegEEG3],
        @"rightEar": (isnan([(NSNumber*)packet.values[IXNEegEEG4] doubleValue])) ? @(0) : packet.values[IXNEegEEG4],
        @"leftAuxiliary": (isnan([(NSNumber*)packet.values[IXNEegAUXLEFT] doubleValue]) == 1) ? @(0) : packet.values[IXNEegAUXLEFT],
        @"rightAuxiliary": (isnan([(NSNumber*)packet.values[IXNEegAUXRIGHT] doubleValue]) == 1) ? @(0) : packet.values[IXNEegAUXRIGHT]
    }];
    // RCTLogInfo(@"Sent: museDataReceived");
}

- (void)receiveMuseArtifactPacket:(nonnull IXNMuseArtifactPacket *)packet muse:(nullable IXNMuse *)muse {
    
}


// - (void) receiveMuseArtifactPacket:(IXNMuseArtifactPacket *)packet
//                               muse:(IXNMuse *)muse
// {
//     if (packet.blink && packet.blink != self.lastBlink) {
//         [self log:@"blink detected"];
//     }
//     self.lastBlink = packet.blink;
// }


RCT_EXPORT_MODULE()

@end
