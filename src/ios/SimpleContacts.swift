import Contacts

func fetchContacts() -> [CNContact] {
    do {
        let store = CNContactStore()
        let keysToFetch = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
        ]
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)

        return contacts

    } catch {
        print(error.localizedDescription)
        return []
    }
}


func toDictionary(contact: CNContact)->[String:Any]{
    var contactDict = [String:Any]()
    contactDict["id"] = contact.identifier
    contactDict["givenName"] = contact.givenName
    contactDict["familyName"] = contact.familyName

    if contact.emailAddresses.count > 0 {
        var emailAddresses = [String]()
        for (_, emailAddress) in contact.emailAddresses.enumerated() {
            emailAddresses.append(emailAddress.value as String)
        }
        contactDict["emailAddresses"] = emailAddresses
    }

    if contact.phoneNumbers.count > 0 {
        var phoneNumbers = [String]()
        for (_, phoneNumber) in contact.phoneNumbers.enumerated() {
            phoneNumbers.append(phoneNumber.value.stringValue)
        }
        contactDict["phoneNumbers"] = phoneNumbers
    }

    if contact.postalAddresses.count > 0 {
        var postalAddresses = [String]()
        for (_, postalAddress) in contact.postalAddresses.enumerated() {
            postalAddresses.append(CNPostalAddressFormatter.string(from: postalAddress.value, style: .mailingAddress))
        }
        contactDict["postalAddresses"] = postalAddresses
    }
    return contactDict
}

/*
 * Notes: The @objc shows that this class & function should be exposed to Cordova.
 */

@objc(SimpleContacts) class SimpleContacts : CDVPlugin, UIActionSheetDelegate {
    @objc(list:) // Declare your function name.
    func list(command: CDVInvokedUrlCommand) { // write the function code.
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */

        var response = [Any]()
        let contacts = fetchContacts()
        for contact in contacts {
            response.append(toDictionary(contact: contact))
        }

        var pluginResult: CDVPluginResult


        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: response);

        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);

    }
}