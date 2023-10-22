# 👾 ListInv 1.0 - Alpha 👾
![image](https://github.com/Gatix1/listinv/assets/69309461/b0069c29-ddd8-4ac0-bde3-a62c5265fe8b)
A demo project of my simple list inventory system that i made for my own project.

## Plans on the project 📋
Before i decided to create this inventory system, i was looking for some similar solutions on the internet, and sadly didn't find literally anything for Godot 4. So i decided to make my own solution. I wanted to make something similar to undertale inventory system, because its something minimalistic and simple, the way i needed it to be.

#### By the way if you're interested in the project you are always welcome to contribute to the repo! 🙏
## Quick Tutorial 📝
- The items are stored as resources! P.S: item_resource
- Inventory node should be on the scene where the player is;
- To add an item you call inventory.add_item("Loaded resource");
- To remove an item you call inventory.remove_item("Loaded resource");
- By default inventory opens on "E", the selection of item/option is setted to ui_left/ui_right/ui_down/ui_up, accept/cancel to ui_accept/ui_cancel; P.S: You can change it in inventory_ui.gd & item_menu.gd
- SoundPlayer and MusicPlayer are the AudioStreamPlayer2D scripts to play the needed audio in one line;

(I added a line of code that adds 2 test items to your inventory when you press A, so you can use it to test the system)
