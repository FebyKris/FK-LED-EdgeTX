# FK LED - EdgeTX RGB Configurator 🚥

**Disclaimer:** I am not a programmer and I know a little how to code. I had specific ideas for how I wanted my radio's LEDs to behave, and I used Gemini AI to write and troubleshoot the actual Lua scripts. Even this `README.md` file was generated with the help of AI! 🤖 This project is a collaborative effort between my concepts and AI coding.

**FK LED** is a touchscreen-friendly, profile-based RGB LED Configurator script for EdgeTX. It was built specifically for radios with addressable RGB Gimbal LEDs (like the Radiomaster TX16S MK3) to help easily switch LED colors and animations at the field.

Developed by **FebyKris**.

Demo Video : https://youtube.com/shorts/2faYx_021ik

## ✨ Key Features
* 👆 **Touchscreen UI:** Card-based user interface optimized for 800x480 screens.
* 👁️ **Live Preview:** See your animation, speed, and color changes in real-time as you tweak them in the UI.
* 🎚️ **3-Profile Switch Override:** Map a 3-position switch (e.g., SA, SB, SC) to store and recall 3 independent LED profiles (Animation, Speed, Primary/Background Colors, and FX).
* 🎨 **Interactive Color Palette:** Pick from 9 predefined solid colors using an on-screen visual palette.
* 🌈 **Rainbow Dynamic FX:** A toggleable modifier that turns your LED trails into shifting rainbows.
* 🚀 **14 Custom Animations:**
  * `Solid` & `Breath`
  * `Wipe Up` & `Wipe Down`
  * `Wipe Left` & `Wipe Right` (Cross-gimbal tracking)
  * `Wipe Center` (Inward tracking)
  * `Alternating` (Left gimbal goes up, right gimbal goes down)
  * `Infinity` (Figure-8 loop)
  * `Infinity Wipe` (Fill and erase loop)
  * `Rainbow` (Smooth color wheel cycle)
  * `Strobe`
  * `Scanner`
  * `Battery` 

## 📂 Installation Guide
1. Go to the **Releases** section on the right side of this page and download the latest `FK_LED_vX.X.zip`.
2. Connect your EdgeTX radio to your computer via USB and select **USB Storage / SD Card**.
3. Extract the contents of the ZIP file directly into the root of your radio's SD Card.
4. Safely disconnect the USB cable.

## 🕹️ How to Use
### Step 1: Activate the Background Script
1. On your radio, press **SYS** and navigate to the **Global Functions** page.
2. Edit one of the existing functions that uses **RGB LEDS** (or create a new one if it doesn't exist).
3. Change the value of that function to `fk_led`. (Your LEDs will now light up).

### Step 2: Configure via UI
1. Press **SYS** and navigate to the **Apps** page.
2. Launch **FK_LED**.
3. Use the touchscreen or roller to navigate the menu:
   * **Input Switch:** Select a 3-position switch (e.g., SA or SB) to unlock Profile Mode.
   * **Setup Position UP/MID/DOWN:** Enter each profile to configure specific animations and colors for that switch position.
4. Changes are saved automatically when you press `[ < Back & Save Profile ]` or exit the tool.

## 🛠️ Compatibility
* **Firmware:** EdgeTX V2.12.1 "Queen Anne's Revenge". (Not yet tested on other versions).
* **Hardware:** Radiomaster TX16S MK3 (Tested). Not tested on other hardware, but it should theoretically work on other EdgeTX radios with addressable Gimbal LEDs (minor adjustments to LED array indexing in `fk_led.lua` might be required).

## ☕ Support This Project
If you find this script useful and want to support my work (or buy me a cup of coffee to fuel my next FPV flight!), you can tip me here:
* [PayPal](https://paypal.me/febykw)

Your support is highly appreciated and will motivate me to create more cool scripts for the community!

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
Feel free to use, modify, and distribute this script, but please keep the original credit to **FebyKris**.


