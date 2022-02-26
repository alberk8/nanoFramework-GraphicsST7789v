using nanoFramework.Hardware.Esp32;
using nanoFramework.Presentation.Media;
using nanoFramework.UI;
using System;
using System.Diagnostics;
using System.Threading;

namespace nanoFramework_ST7789v
{
    public class Program
    {
        public static void Main()
        {
            Debug.WriteLine($"nf Mem { nanoFramework.Runtime.Native.GC.Run(false)}");
            PrintMemory("Start");

            int backLightPin = 32;
            int chipSelect = 5;  //14;
            int dataCommand = 27;
            int reset = 33;
            // Add the nanoFramework.Hardware.Esp32 to the solution
            Configuration.SetPinFunction(19, DeviceFunction.SPI1_MISO);

            Configuration.SetPinFunction(23, DeviceFunction.SPI1_MOSI);
            Configuration.SetPinFunction(18, DeviceFunction.SPI1_CLOCK);

            var dsp = DisplayControl.Initialize(new SpiConfiguration(1, chipSelect, dataCommand, reset, backLightPin),
             new ScreenConfiguration(0, 0, 240, 240));

            //
            //DisplayControl.ChangeOrientation(DisplayOrientation.PORTRAIT180);
          
            Console.WriteLine($"Orientation {DisplayControl.Orientation}");

            Console.WriteLine($"Display Init Size: {dsp} Pixel Size: {DisplayControl.BitsPerPixel}");
            DisplayControl.Clear();

            Bitmap fullScreenBitmap = DisplayControl.FullScreen;

            Font DisplayFont = Resource.GetFont(Resource.FontResources.consolas_regular_16);

            int count = 1;
            int orientationCount = 0;

            while (true)
            {
                if(count % 10 == 0)
                {
                    switch (orientationCount)
                    {
                        case 0:
                            DisplayControl.ChangeOrientation(DisplayOrientation.PORTRAIT);
                            break;
                        case 1:
                            DisplayControl.ChangeOrientation(DisplayOrientation.LANDSCAPE);
                            break;
                        case 2:
                            DisplayControl.ChangeOrientation(DisplayOrientation.PORTRAIT180);
                            break;
                        case 3:
                            DisplayControl.ChangeOrientation(DisplayOrientation.LANDSCAPE180);
                            break;
                    }
                    orientationCount++;
                    orientationCount = orientationCount > 3 ? 0 : orientationCount;
                }
                //PrintMemory("Start");
                var res = count % 2 == 0 ? Resource.BinaryResources.wallpaper : Resource.BinaryResources.waterfall_costa_rica;
                var bitm = Resource.GetBytes(res);
       
                count++;
                using Bitmap bitmap = new Bitmap(bitm, Bitmap.BitmapImageType.Jpeg);
              
                Console.WriteLine($"Create Bitmap Count {count} ");
                PrintMemory("Memory");
            
                var bitmapD = bitmap;
                fullScreenBitmap.Clear();
                fullScreenBitmap.DrawImage(0, 0, bitmapD, 0, 0, bitmapD.Width, bitmapD.Height - fullScreenBitmap.Height > 0 ?
                            fullScreenBitmap.Height : bitmapD.Height);
                
                fullScreenBitmap.DrawText($"{ DateTime.UtcNow.ToString("u")}", DisplayFont, Color.White, 2, 200);
                fullScreenBitmap.DrawText($"Count: {count}", DisplayFont, Color.White, 2, 220);

                fullScreenBitmap.Flush();
                //bitmapD.Flush();

                //bitmap.Dispose();
                //PrintMemory("End");
                Thread.Sleep(100);
            }




        }

        public static void PrintMemory(string msg)
        {
            // The line below will fail with firmware nanoCLR1.bin
             Debug.WriteLine($"nf Mem { nanoFramework.Runtime.Native.GC.Run(false)}");

            NativeMemory.GetMemoryInfo(NativeMemory.MemoryType.Internal, out uint totalSize, out uint totalFree, out uint largestFree);
            Console.WriteLine($"{msg} -> Internal Mem:  Total Internal: {totalSize} Free: {totalFree} Largest: {largestFree}");
        }
    }
}
