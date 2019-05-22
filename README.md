# Codice fiscale

Calculating the tax code for ios has never been easier.

## Requirements

- iOS 10.0+
- Xcode 10

## Integration

### CocoaPods (iOS 10+)

You can use [CocoaPods](http://cocoapods.org/) to install `CodiceFiscale` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target 'MyApp' do
    pod 'CodiceFiscale'
end
```

## Usage

### Initialization

```swift
import CodiceFiscale
```

```swift
let fiscalCodeManager = FiscalCodeManager()
```

Or

```swift
let fiscalCodeManager = FiscalCodeManager(localAuthorietsFileName: <fileName>, localAuthorietsExtension: <extensionName>)
```

With this inizialization you can customize the local authorities list.

### Basics

#### Calculate

````swift
fiscalCodeManager.calculate(name: <name>, surname: <surname>, gender: <gender>, date: <date>, town: <town>, province: <province>)
````

These are the fields needed to calculate the fiscal code:

- Name
- Cognome
- Gender
- Date of Birth
- Town of Birth
- Province of Birth

The function return a nullable value that contain the calculated fiscal code.

#### Retrive information

````swift
fiscalCodeManager.retriveInformationFrom(fiscalCode: <fiscalCode>)
````

The function return a nullable class that contain the all retrieved fields of input fiscal code.


## Info

For more info about fiscal code consult the site: [Codice fiscale](https://it.wikipedia.org/wiki/Codice_fiscale).

## Attention!!

When calculating the Fiscal Code it is possible to incur in the homocody, that is in those cases in which two different people find themselves having an identical Fiscal Code, in order not to take risks we advise you to use the online service of the Revenue Agency and verify the code after having calculated it, thanks to this tool you can check the validity of the tax code, thus avoiding unpleasant surprises or making important official documents invalid.

## License

SwiftMessages is distributed under the MIT license. [See LICENSE](./LICENSE.md) for details.