import { NativeEventEmitter, NativeModules } from 'react-native';

const { RNEegMuseLib } = NativeModules;


// Event listeners
const eegMuseLibObservable = new NativeEventEmitter(RNEegMuseLib);

var _hasTriedConnection = false;
const muselistChangedObserver = eegMuseLibObservable.addListener(
    'muselistChanged',
    async (data) => {
        // Retrieve from evt
        let muselist = data.muselist;
        console.log('muselistChanged: ', muselist);

        // Test retrieval
        try {
            let muselist = await RNEegMuseLib.getMuselist();
            console.log('getMuselist(): ', muselist);
        }
        catch (err) {
            console.log('getMuselist()#error: ', err)
        }

        // Once muse are availables
        let muselistMacAddresses = Object.keys(muselist);
        if (muselistMacAddresses.length > 0 && !_hasTriedConnection) {
            // Get first
            let firstMuseMacAddress = muselistMacAddresses[0];
            let firstMuse = muselist[firstMuseMacAddress];
            console.log('first ' + firstMuseMacAddress + ': ' + firstMuse);

            // Connect to it
            RNEegMuseLib.connectMuse(firstMuseMacAddress);
            _hasTriedConnection = true;

            // ...
            // Will be listened in museConnectionStateChanged
        }
    }
);

// @todo subscribe to observer manually
const museConnectionStateChangedObserver = eegMuseLibObservable.addListener(
    'museConnectionStateChanged',
    (data) => {
        let museMacAddress = data.macAddress;
        let museConnectionState = data.connectionState;
        console.log('first ' + museMacAddress + ': ' + museConnectionState);

        switch(museConnectionState) {
        case 'connecting':
            break;
        case 'connected':
            // @todo subscribe to data events
            break;
        case 'disconnected':
            // @todo close muse listeners (incl. connection one)
            break;
        default:
            // @todo assert - shouldn't happen
        }
    }
);


// @todo subscribe to observer manually
// RNEegMuseLib.subscribeMuseDataReceived();
const museDataReceivedObserver = eegMuseLibObservable.addListener(
    'museDataReceived',
    (data) => {
        console.log('data: ', data);

        let type = data.type;
        let timestamp = data.timestamp;
        let leftEar = data.leftEar;
        let leftForehead = data.leftForehead;
        let rightForehead = data.rightForehead;
        let rightEar = data.rightEar;
        let leftAuxiliary = data.leftAuxiliary;
        let rightAuxiliary = data.rightAuxiliary;
    }
);

// Don't forget to unsubscribe, typically in componentWillUnmount
// muselistObserver.remove();

RNEegMuseLib.subscribeMuselistChanged();
console.log(RNEegMuseLib, RNEegMuseLib.FrameworkVersion);



export default RNEegMuseLib;
