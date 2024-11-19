# (Godot) ValueStateMaintainer
### V1.0.1

## Description
A godot addon to have a consistent exported values, between two states, without relying on themes.

The main utility of the addon is shown as a button at the end of exported properties, in the inspector, and with the autoload singleton named "PalletAccessor"

## How to Use
After enabling the addon (Project > Project Settings > Plugins > ValueStateMaintainer), there are two ways to interact with the addon’s features.

• The first way is through the global singleton ‘PalletAccessor’. Documentation is in the script, but you can use this singleton to affect colors, themes, and values at runtime.

• The second way is Editor Exclusive. On the inspection dock, all valid properties will now have attached a brush button. Clicking on this will show a popup panel that will allow the selection of preferred values. Select whatever values you require for the dark and light modes.
-	There is a button on the top right corner of the Editor, which switches the pallets. F11 is the shortcut key.

## TODO For Future Versions

• Support for properties other than 'Color' and 'int'

• Support Arrays

• Support for property hints and hint_string

• Support Editor Themes

• Fix bug - User becomes locked out of ColorPicker when selecting any item on the **ColorMenu** (the PopupMenu shown upon right clicking on any folder or color in the **ColorTree**). Right click on the ColorPicker to fix temporarily.

• Allow all values, not just colors, to be stored as files in the **ColorTree**

• Maintain **ColorTree** collapsed statuses between editor opens and closes

• Implement 'duplicate' feature in **ColorMenu**

• Implement 'move duplicate' feature in **ColorMenu**

• Implement 'change type' feature in **ColorMenu**

• Allow drag and drop in **ColorTree**

• Allow easier editing of multiple different color pallets

• Consider Triple or more color schemes, instead of one single and dual
