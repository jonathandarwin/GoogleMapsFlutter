# Google Maps in Flutter
1. Get your API KEY here https://developers.google.com/maps/documentation/android-sdk/get-api-key
2. Don't forget to activate <strong>Maps SDK for Android</strong> and <strong>Places API</strong>
3. Add this dependencies in pubspec.yaml. <br>Note: Please update the version if its outdated

        flutter_google_places: 0.2.3
        google_maps_webservice: 0.0.14
        geocoder: 0.2.1
        google_maps_flutter: ^0.4.0
        location: ^1.4.1
        
### This step is for android
3. Add this line of code inside AndroidManifest.xml (inside <application>)

        <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_API_KEY"/>
               
4. Add this line of code inside AndroidManifest.xml (inside <manifest>)
    
        <uses-permission android:name="android.permission.INTERNET"/>
        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
        <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
        
5. Add dependency in build.gradle (Module gradle). <br>Note: Please update the version if its outdated

        implementation 'com.google.android.gms:play-services-maps:16.1.0'
