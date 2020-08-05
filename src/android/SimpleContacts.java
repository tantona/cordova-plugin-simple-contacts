package com.cordova.SimpleContacts;

import java.util.List;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.Manifest;
import android.content.Context;
import androidx.core.content.ContextCompat;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.tomash.androidcontacts.contactgetter.entity.ContactData;
import com.tomash.androidcontacts.contactgetter.main.contactsGetter.ContactsGetterBuilder;
import com.tomash.androidcontacts.contactgetter.entity.NameData;
import com.tomash.androidcontacts.contactgetter.entity.PhoneNumber;
import com.tomash.androidcontacts.contactgetter.entity.Email;
import com.tomash.androidcontacts.contactgetter.entity.Address;


public class SimpleContacts extends CordovaPlugin {
    private static final int PERMISSIONS_REQUEST_READ_CONTACTS = 55434;
    private CallbackContext callbackContext;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
        if (action.equals("listContacts")) {
            this.listContacts();
            return true;
        }
        return false;
    }

    private void listContacts() throws JSONException {
        Context ctx = this.cordova.getActivity().getApplicationContext();
        if (ContextCompat.checkSelfPermission(ctx, Manifest.permission.READ_CONTACTS) == PackageManager.PERMISSION_GRANTED) {
            this.fetchContacts();
        } else {
            cordova.requestPermissions(this, PERMISSIONS_REQUEST_READ_CONTACTS, new String[]{Manifest.permission.READ_CONTACTS});
        }
    }

    @Override
    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException {
        if (requestCode == PERMISSIONS_REQUEST_READ_CONTACTS) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                this.fetchContacts();
                return;
            }
        }

        callbackContext.error("app does not have permissions to read contacts");
    }


    public void fetchContacts() throws JSONException {
        Activity activity = this.cordova.getActivity();
        Context ctx = activity.getApplicationContext();
        List<ContactData> contacts = new ContactsGetterBuilder(ctx)
                .allFields()
                .buildList();

        JSONArray contactList = new JSONArray();
        for (ContactData contact : contacts) {
            JSONObject item = new JSONObject();

            NameData name = contact.getNameData();

            item.put("givenName", name.getFirstName());
            item.put("familyName", name.getSurname());

            JSONArray postalAddresses = new JSONArray();
            for (Address address : contact.getAddressesList()) {
                postalAddresses.put(address.getMainData());
            }
            item.put("postalAddresses", postalAddresses);

            JSONArray emailAddresses = new JSONArray();
            for (Email email : contact.getEmailList()) {
                emailAddresses.put(email.getMainData());
            }
            item.put("emailAddresses", emailAddresses);

            JSONArray phoneNumbers = new JSONArray();
            for (PhoneNumber phoneNumber : contact.getPhoneList()) {
                phoneNumbers.put(phoneNumber.getMainData());
            }
            item.put("phoneNumbers", phoneNumbers);

            contactList.put(item);
        }

        // callbackContext.success(contactList.toString());
        PluginResult result = new PluginResult(PluginResult.Status.OK, contactList); // You can send data, String, int, array, dictionary and etc
        result.setKeepCallback(false);
        callbackContext.sendPluginResult(result);
    }
}
