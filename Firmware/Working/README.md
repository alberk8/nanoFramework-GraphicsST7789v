# Working Firmware (nanoCLR_2.bin)

This is firmware is compiled with the following change

- cmake-variants for ESP_WROVER_KIT
- src -> nanoFramework.Graphics 
    - Display -> ST7789V_240x320_SPI.cpp
    - Graphics -> Core -> GraphicsDriver.cpp
    - Native -> nanoFramework_Graphics_nanoFramework_UI_DisplayControl.cpp
- tragets
    - ESP32
        - _IDF -> sdkconfig.default
            - esp32 -> app_main.c (switch the core)
        - _nanoCLR -> Memory.cpp & target_platform.h.in