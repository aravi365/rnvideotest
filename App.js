/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import type {Node} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  Button,
  NativeModules,
} from 'react-native';
import VideoPlayer from './IOSVideoView';

//access video manager for controlling playback
const {PsVideoViewManager: VideoManager} = NativeModules;

const App = () => {
  const [videoUri, setVideoUri] = React.useState(
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
  );
  // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',

  const [showVideo, setShowVideo] = React.useState(true);
  const videoRef = React.useRef(null);
  // console.log('video ref', videoRef);
  return (
    <SafeAreaView style={styles.safeArea}>
      {showVideo && videoUri ? (
        <VideoPlayer
          ref={videoRef}
          style={styles.videoPlayer}
          play={true}
          url={videoUri}
        />
      ) : null}
      <Button
        title="Set new Video"
        onPress={() => {
          // setVideoUri(
          //   'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          // );
          VideoManager.playAnotherVideo(
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          );
        }}
      />
      <Button
        title="toggle video"
        onPress={() => {
          setShowVideo(prevState => !prevState);
        }}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: 'white',
    alignItems: 'center',
    justifyContent: 'center',
  },
  videoPlayer: {
    height: 200,
    width: '100%',
    borderWidth: 1,
    backgroundColor: 'black',
  },
});

export default App;
