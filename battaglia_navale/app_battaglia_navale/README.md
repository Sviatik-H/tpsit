# Client Mobile

>Per far si che l'app abbia i permessi di collegarsi al *server* una volta inserito l'**ip**, bisogna assicurarsi che nel file `AndroidManifest.xml` ci siano dentro il tag `manifest` queste due rige:
>```xml
><uses-permission android:name="android.permission.INTERNET" />
><uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
>```
