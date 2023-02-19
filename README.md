# Demo Stone Deeplink

A Delphi (Firemonkey) demo project for integration with Stone's card machine

## ⚙️ Installing dependencies

With the project closed, go to the folder where the project is located and run the command [`boss install`](https://github.com/HashLoad/boss) in your terminal:
``` sh
boss install
```
After running, just open the project and enjoy!

## ⚙️ Configuration

According to [`documentation`](https://sdkandroid.stone.com.br/reference/configuracao-deeplink), it's necessary to define a name for the *scheme*. By default, the demo project was set to "demo_stone_deeplink", remember to change it in your real project.

### ⚡️ Changes to *AndroidManifest*:

``` xml
<intent-filter>
  ...
    <data
        android:host="pay-response"
        android:scheme="demo_stone_deeplink" />
</intent-filter>
```
``` xml
<intent-filter>
  ...
    <data
        android:host="cancel"
        android:scheme="demo_stone_deeplink" />
</intent-filter>
```

### ⚡️ Changes to the StoneDeeplink component:

Go to *Object Inspect*, find *Scheme* property and change it according to the same name defined in *AndroidManifest*
