/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, NativeModules, Button,AppRegistry} from 'react-native';


const RNAccept = NativeModules.RNAccept;
RNAccept.configure('6AB64hcB', '6gSuV295YD86Mq4d86zEsx8C839uMVVjfXm9N4wr6DRuhTHpDU97NFyKtfZncUq8');

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {

  async onPressLearnMore() {
    try {
      let response = await RNAccept.doCardPayment(
        '4361235460436582',
        '11',
        '23',
        '125'
      );
      console.log('Response is ', response);
    } catch(e) {
      console.log('Error is ', e)
    }
    
  }

  async onApplePay () {
    try {
      let response = await RNAccept.doApplePay();
      console.log('Apple pay Response is ', response);
    } catch(e) {
      console.log('Error is ', e)
    }
  }
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        <Text style={styles.instructions}>To get started, edit App.js</Text>
        <Text style={styles.instructions}>{instructions}</Text>
        <Text style={styles.hello}>Hello React Native</Text>
        <Button   
           onPress={this.onPressLearnMore}   
           title="Learn Moreasdfasdfasdf"   
           color="#841584"
        />

        <Button   
           onPress={this.onApplePay}   
           title="Apple Pay"   
           color="#841584"
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
AppRegistry.registerComponent('AcceptSDK', () => App);