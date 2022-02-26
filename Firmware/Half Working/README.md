# Half Working Firmware (nanoCLR_1.bin)

This is firmware is compiled with the following change

- cmake-variants for ESP_WROVER_KIT
- src -> nanoFramework.Graphics 
    - Display -> ST7789V_240x320_SPI.cpp
    - Graphics -> Core -> GraphicsDriver.cpp
    - Native -> nanoFramework_Graphics_nanoFramework_UI_DisplayControl.cpp
- tragets
    - ESP32
        - _nanoCLR -> Memory.cpp & target_platform.h.in

The app wil deploy without problem after a fresh flashing of the firmware but subsequent deploy will fail and only way was to unplug the ESP.
Another problem is that the unit will hang when Debug.WriteLine($"nf Mem { nanoFramework.Runtime.Native.GC.Run(false)}"); is called after the graphics DisplayControl.Initialize is called.