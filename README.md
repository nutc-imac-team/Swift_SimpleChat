# Firebase_SimpleChat

利用Firebase(Authentication、Database、Storage)，建立一個擁有基本功能的訊息傳遞App。

# How Use

https://console.firebase.google.com/
到irebase後台創建專案，建立iOS應用，接著下載GoogleService-Info.plist，將它拉至Xcode專案中。

＊ BUNDLE_ID需與Xcode專案Bundle identifier相同。 

# Pod init

add to podfile：

pod 'Firebase/Auth'

pod 'Firebase/Database'

pod 'Firebase/Storage'

pod ‘Toaster’

->pod install
