import * as React from 'react';

import {StyleSheet, View, Text, Platform, Button} from 'react-native';
import UnityAds from 'react-native-unity-ads-monetization';

export default function App() {
  const [loaded, setLoaded] = React.useState(false);
  React.useEffect(() => {
    const gameId = Platform.select({
      android: 'YOUR_GAME_ID',
      ios: 'YOUR_GAME_ID',
    });
    UnityAds.setOnUnityAdsLoadListener({
      onAdLoaded: (placementId: string) => {
        console.log(`UnityAds.onAdLoaded: ${placementId}`);
        setLoaded(true);
      },
      onAdLoadFailed: (placementId: string, message: string) => {
        setLoaded(false);
        console.error(`UnityAds.onAdLoadFailed: ${placementId}, ${message}`);
      }
    });
    UnityAds.setOnUnityAdsShowListener({
      onShowStart: (placementId: string) => {
        console.log(`UnityAds.onShowStart: ${placementId}`)
      },
      onShowComplete: (placementId: string, state: 'Skipped' | 'Completed') => {
        console.log(`UnityAds.onShowComplete: ${placementId}, ${state}`)
      },
      onShowFailed: (placementId: string, message: string) => {
        console.error(`UnityAds.onShowFailed: ${placementId}, ${message}`)
      },
      onShowClick: (placementId: string) => {
        console.log(`UnityAds.onShowClick: ${placementId}`)
      }
    });

    UnityAds.initialize(gameId!, true)
      .then(_ => {
        return UnityAds.loadAd('rewardedVideo');
      })
  }, []);

  return (
    <View style={styles.container}>
      <Text>Ads loaded: {loaded ? 'true' : 'false'}</Text>
      <Button
        disabled={!loaded}
        onPress={() => {
          UnityAds.showAd('rewardedVideo');
        }}
        title={'show ads'}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
