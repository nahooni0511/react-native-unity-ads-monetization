
# React Native Unity Ads Monetization Module

This module enables React Native applications to integrate Unity Ads, providing a simple way to include ads into your mobile app for monetization. Based on Unity Ads SDK version 4.7.0, this module is designed to be easy to use, allowing developers to show ads from Unity with minimal setup.

## Features

- Initialize Unity Ads with a single call.
- Load and display ads with easy-to-use functions.
- Callbacks for ad events such as loading, showing, and errors.
- Support for both Android and iOS platforms.

## Installation

```bash
npm install react-native-unity-ads-monetization
# or
yarn add react-native-unity-ads-monetization
```

## Setup

1. Import the module in your React Native project.

```javascript
import UnityAds from 'react-native-unity-ads-monetization';
```

2. Initialize Unity Ads with your game ID and set up listeners for ad events.

```javascript
const gameId = Platform.select({
  android: 'YOUR_ANDROID_GAME_ID',
  ios: 'YOUR_IOS_GAME_ID',
});

UnityAds.initialize(gameId, true).then(() => {
  UnityAds.loadAd('rewardedVideo');
});
```

3. Load and show ads in your app.

```javascript
if (loaded) {
  UnityAds.showAd('rewardedVideo');
}
```

## Usage Example

Below is a simple example demonstrating how to use the Unity Ads module in a React Native app.

```javascript
import React, { useState, useEffect } from 'react';
import { View, Text, Button, Platform, StyleSheet } from 'react-native';
import UnityAds from 'react-native-unity-ads-monetization';

export default function App() {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const gameId = Platform.select({
      android: 'YOUR_ANDROID_GAME_ID',
      ios: 'YOUR_IOS_GAME_ID',
    });

    UnityAds.initialize(gameId, true)
      .then(_ => UnityAds.loadAd('rewardedVideo'));

    UnityAds.setOnUnityAdsLoadListener({
      onAdLoaded: (placementId) => {
        console.log(`UnityAds.onAdLoaded: ${placementId}`);
        setLoaded(true);
      }
    });

    // Add other event listeners as needed
  }, []);

  return (
    <View style={styles.container}>
      <Text>Ads loaded: {loaded ? 'true' : 'false'}</Text>
      <Button
        disabled={!loaded}
        onPress={() => UnityAds.showAd('rewardedVideo')}
        title={'Show Ads'}
      />
    </View>
  );
}

// Styles for your app
const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
```

## License

This project is open source and available under the MIT License. This means you are free to use, share, and adapt it for your needs with appropriate attribution.

Feel free to contribute to the project on GitHub and help make it even better!
