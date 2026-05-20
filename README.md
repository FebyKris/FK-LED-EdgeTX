# FK LED - EdgeTX RGB Configurator 🚥

**Disclaimer:** I am not a programmer and I do not know how to code. I had specific ideas for how I wanted my radio's LEDs to behave, and I used Gemini AI to write and troubleshoot the actual Lua scripts. Even this `README.md` file was generated with the help of AI! 🤖 This project is a collaborative effort between my FPV concepts and AI coding.

**FK LED** is a touchscreen-friendly, profile-based RGB LED Configurator script for EdgeTX. It was built specifically for radios with addressable RGB Gimbal LEDs (like the Radiomaster TX16S MK3) to help easily switch LED colors and animations at the field.

Developed by **FebyKris**.

## ✨ Key Features
* 👆 **Touchscreen UI:** Card-based user interface optimized for 800x480 screens.
* 👁️ **Live Preview:** See your animation, speed, and color changes in real-time as you tweak them in the UI.
* 🎚️ **3-Profile Switch Override:** Map a 3-position switch (e.g., SA, SB, SC) to store and recall 3 independent LED profiles (Animation, Speed, Primary/Background Colors, and FX).
* 🎨 **Interactive Color Palette:** Pick from 9 predefined solid colors using an on-screen visual palette.
* 🌈 **Rainbow Dynamic FX:** A toggleable modifier that turns your LED trails into shifting rainbows.
* 🚀 **11 Custom Animations:**
  * `Solid` & `Breath`
  * `Wipe Up` & `Wipe Down`
  * `Wipe Left` & `Wipe Right` (Cross-gimbal tracking)
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
3. Select `fk_led` from the script list.

### Step 2: Configure via UI
1. Press **SYS** and navigate to the **Tools** page.
2. Launch **FK_LED**.
3. Use the touchscreen or roller to navigate the menu:
   * **Input Switch:** Select a 3-position switch (e.g., SA or SB) to unlock Profile Mode.
   * **Setup Position UP/MID/DOWN:** Enter each profile to configure specific animations and colors for that switch position.
4. Changes are saved automatically when you press `[ < Back & Save Profile ]` or exit the tool.

## 🛠️ Compatibility
* **Firmware:** EdgeTX 2.8 or newer.
* **Hardware:** Radiomaster TX16S MK3 (Tested). It should work on other EdgeTX radios with addressable Gimbal LEDs (minor adjustments to LED array indexing in `fk_led.lua` might be required).

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
Feel free to use, modify, and distribute this script, but please keep the original credit to **FebyKris**.
