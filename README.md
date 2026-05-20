# FK LED - Advanced EdgeTX RGB Configurator 🚥

**FK LED** is a powerful, touchscreen-friendly, and profile-based RGB LED Configurator script for EdgeTX. Built specifically for radios with addressable RGB Gimbal LEDs (like the Radiomaster TX16S MK3).

Forget static colors. This script transforms your radio's LED rings into a fully customizable, dynamic visual indicator with **Live Preview** and **Flight-Mode Style Switch Profiles**, all configurable right from your radio's screen!

Developed by **FebyKris**.

## ✨ Key Features
* 👆 **Touchscreen UI:** Intuitive, card-based user interface optimized for high-resolution screens (800x480).
* 👁️ **Live Preview Engine:** See your animation, speed, and color changes in real-time as you tweak them in the UI.
* 🎚️ **3-Profile Switch Override:** Map a 3-position switch (e.g., SA, SB, SC) to store and instantly recall 3 completely independent LED profiles (Animation, Speed, Primary/Background Colors, and FX).
* 🎨 **Interactive Color Palette:** Pick from 9 predefined solid colors using an on-screen visual palette.
* 🌈 **Rainbow Dynamic FX:** A toggleable modifier that turns your LED trails into dynamic, shifting rainbows.
* 🚀 **11 Custom Animations:**
  * `Solid` & `Breath`
  * `Wipe Up` & `Wipe Down`
  * `Wipe Left` & `Wipe Right` (Smooth cross-gimbal tracking)
  * `Wipe Center` (Inward tracking)
  * `Alternating` (Left gimbal goes up, right gimbal goes down)
  * `Infinity` (Figure-8 loop)
  * `Infinity Wipe` (Fill and erase loop)
  * `Rainbow` (Smooth color wheel cycle)

## 📂 Installation Guide

1. Download this repository as a ZIP file and extract it.
2. Connect your EdgeTX radio to your computer via USB and select **USB Storage / SD Card**.
3. Copy the files to your SD Card, maintaining this exact folder structure:
   * `SD Card/SCRIPTS/TOOLS/FK_LED.lua`
   * `SD Card/SCRIPTS/RGBLED/fk_led.lua`
4. Disconnect the USB cable.

## 🕹️ How to Use

### Step 1: Activate the Background Script
1. On your radio, press **SYS** and go to the **Radio Setup** page.
2. Scroll down to the **RGB LED** section.
3. Select `fk_led` from the script list. (Your LEDs will now light up).

### Step 2: Configure via UI
1. Press **SYS** and navigate to the **Tools** page.
2. Launch **FK_LED**.
3. Use the touchscreen or roller to navigate the menu:
   * **Input Switch:** Select a 3-position switch (e.g., SA or SB) to unlock Profile Mode.
   * **Setup Position UP/MID/DOWN:** Enter each profile to configure specific animations and colors for that switch position.
4. Changes are saved automatically when you press `[ < Back & Save ]` or exit the tool!

## 🛠️ Compatibility
* **Firmware:** EdgeTX 2.8 or newer.
* **Hardware:** Radiomaster TX16S MK3 (Tested). It should work flawlessly on other EdgeTX radios with addressable Gimbal LEDs (minor adjustments to LED array indexing in `fk_led.lua` might be required for different LED counts).

## 🤝 Contributing
Feel free to fork this project, submit pull requests, or open an issue if you have ideas for new animations or features! Happy flying! 🚁


## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
Basically, feel free to use, modify, and distribute this script, but please keep the original credit to **FebyKris**.
