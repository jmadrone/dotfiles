# My macOS Smartcard Enforcement Documentation

**Author**: Josh Madrone  
**Date**: Dec 29, 2024
**Hashtags**: #macos, #smartcard, #yubikey, #sysadmin, #filevault

This document is a customized version of Apple's own documentation, tailored for Emerald Security's use on our Mac's.

We've chosen to go with the **User-Based Enforcement** option as we don't have an MDM platform, with an exempted group named `NotEnforced`, to allow members of that group to login without the use of a smartcard.

Group members include: `sysadmin` and `plex` (sharing only).

Deployment consisted of:

1. Place a copy of `SmartcardLogin.plist` at `/private/etc/SmartcardLogin.plist`, ensuring that it is world-readable, usually owned by `root:wheel`.
2. Issue the following command to enforce use of smartcards

        sudo defaults write /Library/Preferences/com.apple.security.smartcard enforceSmartCard -bool true
3. Issue the following command to allow unmapped users to login (those users that have not been paired with a smartcard)

        sudo defaults write /Library/Preferences/com.apple.security.smartcard allowUnmappedUsers -int 1

---

## Configure a Mac for smart card--only authentication

macOS supports smart card--only authentication for the mandatory use of a smart card, which disables all password-based authentication. This policy is established across all Mac computers, and can be changed on a per-user basis using an exemption group, in the event that a user doesn't have a working smart card available.

## Smart card--only authentication using machine based enforcement

macOS 10.13.2 or later supports smart card--only authentication for the mandatory use of a smart card, which disables all password-based authentication and is often called _machine based enforcement_. To leverage this feature, mandatory smart card enforcement must be established using a mobile device management (MDM) solution or by using the following command:

```sh
sudo defaults write /Library/Preferences/com.apple.security.smartcard enforceSmartCard -bool true
```

For additional instructions on configuring macOS for smart card--only authentication, see the Apple Support article [Configure macOS for smart card-only authentication](https://support.apple.com/HT208372).

## Smart card--only authentication using user based enforcement

User based enforcement is accomplished by specifying a user group that's exempted from smart card login. `NotEnforcedGroup` contains a string value that defines the name of a local or Directory group that won't be included in mandatory smart card enforcement. This is sometimes referred to as _user based enforcement_ and provides per-user granularity to smart card services. To leverage this feature, machine based enforcement must first be established using a mobile device management (MDM) solution or by using the following command:

```sh
sudo defaults write /Library/Preferences/com.apple.security.smartcard enforceSmartCard -bool true
```

In addition, the system must be configured to allow users who aren't paired with a smart card to log in with their password:

```sh
sudo defaults write /Library/Preferences/com.apple.security.smartcard allowUnmappedUsers -int 1
```

Use the example `/private/etc/SmartcardLogin.plist` file below as guidance. Use `EXEMPT_GROUP` for the name of the group used for exemptions. Any user you add to this group is exempt from smart card login, as long as they're a specified member of the group or the group itself is specified for exemption. Verify that the ownership is root and that permissions are set to "world readable" after editing.

File: `/private/etc/SmartcardLogin.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>AttributeMapping</key>
        <dict>
            <key>dsAttributeString</key>
            <string>dsAttrTypeStandard:AltSecurityIdentities</string>
            <key>fields</key>
            <array>
                <string>NT Principal Name</string>
            </array>
            <key>formatString</key>
            <string>Kerberos:$1</string>
        </dict>
        <key>NotEnforcedGroup</key>
        <string>NotEnforced</string>
    </dict>
</plist>
```

## Temporary Exemption  

On an Apple Silicon Mac, if a temporary exemption is needed, `security filevault skip-sc-enforcement` will disable smartcard enforcement on next boot only.  
Run the following command to set the temporary exemption when booted from Recovery:  

    /usr/bin/security filevault skip-sc-enforcement <data volume UUID> set  
To obtain the `data volume UUID` run the following:  

    /usr/sbin/diskutil apfs listGroups | /usr/bin/awk -F: '/ Data/ { getline; gsub(/ /,""); print $2}'  
Mac Studio Data Volume UUID
    81F936DA-87C0-487D-A81C-3563B3129D2B

[View solution in original post](https://community.jamf.com/t5/jamf-pro/smartcard-filevault2-and-m1-silicon-macbooks-oh-my/m-p/282073)

## Got another easier solution, tested and confirmed working.

To bypass FV2 on Silicon macBook with SmartCard Enforcement enabled...

1. Boot up Silicon macBook normally  
2. Press **Option Shift Return** and you will be prompted for Personal Recovery Key  
3. Enter the Personal Recovery Key and proceed.  

macBook will now authenticate past the FV2 screen, allowing network communication with MDM. You may also login using SmartCard Excluded account which wasn't FV2 enabled (no SmartToken).

[View solution in original post](https://community.jamf.com/t5/jamf-pro/smartcard-filevault2-and-m1-silicon-macbooks-oh-my/m-p/283065)
