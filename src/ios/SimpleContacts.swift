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

        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts = [CNContact]()

        try store.enumerateContacts(with: request) {
            (contact, stop) in contacts.append(contact)
        }


        contacts.sort {
            $0.familyName > $1.familyName
        }

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
        var postalAddresses = [[String:String]]()
        for (_, postalAddress) in contact.postalAddresses.enumerated() {
            var pa = [String:String]()
            pa["city"] = postalAddress.value.city
            pa["street"] = postalAddress.value.street
            pa["country"] = postalAddress.value.country
            pa["state"] =  postalAddress.value.state
            pa["postalCode"] =  postalAddress.value.postalCode
            pa["subAdministrativeArea"] =  postalAddress.value.subAdministrativeArea
            pa["subLocality"] =  postalAddress.value.subLocality
            postalAddresses.append(pa)
        }
        contactDict["postalAddresses"] = postalAddresses
    }
    return contactDict
}


@objc(SimpleContacts) class SimpleContacts : CDVPlugin, UIActionSheetDelegate {
    @objc(list:)
    func list(command: CDVInvokedUrlCommand) {
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
