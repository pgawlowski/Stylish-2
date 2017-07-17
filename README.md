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
Available properties are retrived in a dynamic way using 
```
class_copyPropertyList
```
Thanks to this most of properties are being covered in Stylish. To get available properties for certain class you can use in console
```
UIButton().retriveDynamicPropertySet()
UILabel().retriveDynamicPropertySet()
etc.
```

Available property list will be linked in a separate doc later.
### Basic structure
```
{
    "styleClass" : "ClassExmapleName",
    "properties" : [
                    {
                    "propertySetName" : "UILabelPropertySet",
                    "propertyName" : "textColor",
                    "propertyType" : "UIColor",
                    "propertyValue" : "#C7C7CD"
                    },
```
This is the basic structure of .json stylesheet property. `propertySetName` should refer to one of available:
- UIViewPropertySet
- UILabelPropertySet
- UIButtonPropertySet
- UITextFieldPropertySet
- UIImageViewPropertySet
- UIFontPropertySet

`propertySetName` - supposed to be the exact name as property we want to set
`propertyType` - supposed to be the exact type of property we want to modify

### Mixing styles
```
{
    "styleClass" : "UILabel.StandardLabel",
    "styles" : [
                "UIFont.OpenSans",
                "UIFont.Normal",
                "UILabel.TextAlignment.Left",
                "UILabel.TextColor.HybrisBlack",
                ]
},
```

It is possible to apply already defined styles together. In that case basic structure requires `styleClass` name as a name we're referring to and `styles` list for styles we're referring to. If any element covers the same propperties the last one will be applied (it will override previously set properties eg. 
```
{
    "styleClass" : "UILabel.Position",
    "styles" : [
                "UILabel.TextAlignment.Left",
                "UILabel.TextAlignment.Right",
                ]
},
```
will override left text alignment and apply right text alignment. 

### UIButton
```
{
    "styleClass" : "UIButton.StandardInput",
    "properties" : [
                    {
                    "propertySetName" : "UILabelPropertySet",
                    "propertyName" : "textColor",
                    "propertyType" : "UIColor",
                    "propertyValue" : "#C7C7CD"
                    },
                    {
                    "propertySetName" : "UIViewPropertySet",
                    "propertyName" : "layer.backgroundColor",
                    "propertyType" : "CGColor",
                    "propertyValue" : "#FFFFFF"
                    },
                    {
                    "propertySetName" : "UIViewPropertySet",
                    "propertyName" : "layer.borderColor",
                    "propertyType" : "CGColor",
                    "propertyValue" : "#C7C7CD"
                    },
                    {
                    "propertySetName" : "UIViewPropertySet",
                    "propertyName" : "layer.borderWidth",
                    "propertyType" : "CGFloat",
                    "propertyValue" : 0.5
                    },
                    {
                    "propertySetName" : "UIViewPropertySet",
                    "propertyName" : "layer.cornerRadius",
                    "propertyType" : "CGFloat",
                    "propertyValue" : 5.0
                    }
                    ]
},
```
Most of visial elements of UIButton requires to apply propeties on layer eg. `layer.borderColor`, `layer.borderWidth` etc. for more just list properties using `UIButton().retriveDynamicPropertySet()`

### UIFont
In the same way we can apply UIFont styles. It can be done in a separate way allowing us to mix the styling and build the font that is required as well as define one whole font for all properties. This rule applies to all styles.
```
{
  "styleClass" : "UIFont.OpenSans",
  "properties" : [
              {
                  "propertySetName" : "UIFontPropertySet",
                  "propertyName" : "font",
                  "propertyType" : "UIFont",
                  "propertyValue" : {
                  "fontName" : "OpenSans",
                  }
                  },
                  ]
  },
  {
    "styleClass" : "UIFont.Small",
    "properties" : [
                    {
                    "propertySetName" : "UIFontPropertySet",
                    "propertyName" : "font",
                    "propertyType" : "UIFont",
                    "propertyValue" : {
                    "pointSize" : 14,
                    }
                    },
                    ]
},
  {
    "styleClass" : "UIFont.Italic",
    "properties" : [
                    {
                    "propertySetName" : "UIFontPropertySet",
                    "propertyName" : "font",
                    "propertyType" : "UIFont",
                    "propertyValue" : {
                    "weight" : "Italic",
                    }
                    },
                    ]
},
```
Separate styling for `UIFont`

```
{
  "styleClass" : "UIFont.OpenSans",
  "properties" : [
              {
                  "propertySetName" : "UIFontPropertySet",
                  "propertyName" : "font",
                  "propertyType" : "UIFont",
                  "propertyValue" : {
                  "fontName" : "OpenSans",
                  "pointSize" : 14,
                  "weight" : "Italic",
                  }
                  },
                  ]
  },
```
Single `styleClass` mixing all required properties.

Be aware that weight must be available for font you are using! 
