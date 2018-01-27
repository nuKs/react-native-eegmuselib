using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Eeg.Muse.Lib.RNEegMuseLib
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNEegMuseLibModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNEegMuseLibModule"/>.
        /// </summary>
        internal RNEegMuseLibModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNEegMuseLib";
            }
        }
    }
}
