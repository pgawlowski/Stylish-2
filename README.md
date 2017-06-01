# Stylish-2
Based on https://github.com/daniel-hall/Stylish

### Stylesheets for Storyboards
Stylish is a library that lets you create stylesheets in code or in JSON to controll nearly any available property in UIView, UILabel, UIButton, UIImage, UITextfield as well as applying multiple styles and overriding properties.

Whole project is based on https://github.com/daniel-hall/Stylish but it's changing the philosophy of setting properties, wrapping around elements rather then hardcoiding them. This allows as to access any property that is available in runtime as well as few additinal like UIFonts.

## Installation
Best way to install is to use cocoapods
```
pod 'Stylish-2', :git => 'https://github.com/pgawlowski/Stylish-2.git'
```
## Configuration
Stylish requires few additional things to configure before proper use.

First you need to add additional script to handle .json files with styles. Add script in targets 
```
BuildPhases->New Run Scrip Phase
```
right under ``Check Pods Manifest.lock``

Script:
```
> ${SRCROOT}/stylesheet.json
echo [ >> ${SRCROOT}/stylesheet.json
for file in ${SRCROOT}/ExampleProject/StylesheetStyles/* ;
do
pbcopy < $file
pbpaste >> ${SRCROOT}/stylesheet.json
done
echo ] >> ${SRCROOT}/stylesheet.json
```
In main project folder add file ``stylesheet.json`` and remember to add a reference in project to it. It is crucial to crete file in main folder. This will be the final ``.json`` file with styles.

In ``StylesheetStyles`` you will insert your custom style files.


## Examples

