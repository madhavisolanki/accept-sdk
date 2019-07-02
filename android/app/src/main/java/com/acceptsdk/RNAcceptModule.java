package com.acceptsdk;

import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import net.authorize.acceptsdk.AcceptSDKApiClient;
import net.authorize.acceptsdk.AcceptSDKApiClient.Builder;

import net.authorize.acceptsdk.datamodel.common.Message;
import net.authorize.acceptsdk.datamodel.transaction.EncryptTransactionObject;
import net.authorize.acceptsdk.datamodel.merchant.ClientKeyBasedMerchantAuthentication;
import net.authorize.acceptsdk.datamodel.transaction.TransactionObject;
import net.authorize.acceptsdk.datamodel.transaction.TransactionType;
import net.authorize.acceptsdk.datamodel.transaction.CardData;
import net.authorize.acceptsdk.datamodel.transaction.callbacks.EncryptTransactionCallback;
import net.authorize.acceptsdk.datamodel.transaction.response.EncryptTransactionResponse;
import net.authorize.acceptsdk.datamodel.transaction.response.ErrorTransactionResponse;

import com.facebook.react.bridge.Promise;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONException;
import org.json.JSONObject;


public class RNAcceptModule extends ReactContextBaseJavaModule {

    ReactApplicationContext reactContext;
    AcceptSDKApiClient apiClient;
    String API_LOGIN_ID;
    String CLIENT_KEY;


    public RNAcceptModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.apiClient = new Builder(reactContext, AcceptSDKApiClient.Environment.SANDBOX)
            .connectionTimeout(5000)
            .build();
    }

    private EncryptTransactionObject prepareTransactionObject(String cardNumber, String expirationMonth, String expirationYear, String cvvCode) {
        ClientKeyBasedMerchantAuthentication merchantAuthentication =
                ClientKeyBasedMerchantAuthentication.
                        createMerchantAuthentication(API_LOGIN_ID, CLIENT_KEY);

        // create a transaction object by calling the predefined api for creation
        return TransactionObject.
                createTransactionObject(
                        TransactionType.SDK_TRANSACTION_ENCRYPTION) // type of transaction object
                .cardData(prepareCardDataFromFields(cardNumber, expirationMonth, expirationYear, cvvCode)) // card data to get Token
                .merchantAuthentication(merchantAuthentication).build();
    }

    private CardData prepareCardDataFromFields(String cardNumber, String expirationMonth, String expirationYear, String cvvCode) {
        return new CardData.Builder(cardNumber, expirationMonth, expirationYear).cvvCode(cvvCode) //CVV Code is optional
                .build();
    }

    @ReactMethod
    public void configure (String apiLoginId, String clientKey) {
        this.API_LOGIN_ID = apiLoginId;
        this.CLIENT_KEY = clientKey;
    }

    @ReactMethod
    public void doCardPayment (String cardNumber, String expirationMonth, String expirationYear, String cvvCode, Promise p) {
        try {
            EncryptTransactionObject transactionObject = prepareTransactionObject(cardNumber, expirationMonth, expirationYear, cvvCode);
            Gson gson = new GsonBuilder().create();
            apiClient.getTokenWithRequest(transactionObject, new EncryptTransactionCallback() {
                @Override
                public void onErrorReceived(ErrorTransactionResponse errorResponse) {
                    Message error = errorResponse.getFirstErrorMessage();
                    p.reject(error.getMessageCode(), error.getMessageText());
                }

                @Override
                public void onEncryptionFinished(EncryptTransactionResponse response) {
                    p.resolve(gson.toJson(response));
                }
            });
        } catch (NullPointerException e) {
            // Handle exception transactionObject or callback is null.
            p.reject("0", "Unknown Error: " + e.getStackTrace());
            e.printStackTrace();
        }
    }

    @Override
    public String getName() {
        return "RNAccept";
    }
}
