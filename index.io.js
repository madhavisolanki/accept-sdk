import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button,
  Platform,
  NativeModules
} from 'react-native';
class App extends React.Component {
  
  onPressLearnMore() {
      if (Platform.OS === 'ios') {
        NativeModules.Manager.getAPI()
      }
  }
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.hello}>Hello React Native</Text>
        <Button   
           onPress={onPressLearnMore}   
           title="Learn More"   
           color="#841584"
        />
      </View>
    )
  }
}
var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
  },
  hello: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
});
AppRegistry.registerComponent('AcceptSDK', () => App);