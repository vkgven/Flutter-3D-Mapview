# Flutter-3D-Mapview

Map view with 3D Building in Flutter 

Things needed…

1.Add google_maps_flutter in the pubspec.yaml

2.Get an API key at https://cloud.google.com/maps-platform/.

3.For Android : Specify your API key in the application manifest android/app/src/main/AndroidManifest.xml
        <meta-data android:name="com.google.android.geo.API_KEY"
          android:value="YOUR_KEY"/>
          
4.For iOS : Specify your API key in the application delegate ios/Runner/AppDelegate.m
    #import “GoogleMaps/GoogleMaps.h”
    [GMSServices provideAPIKey:@”YOUR KEY HERE”]
    
    
    
