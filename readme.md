# Patched Atheros Driver for Toshiba WLM-20u2

Status: historical/unmaintained, just use a more recent kernel

This is a rip from linux-source-3.13.0 which is patched to do 3 things.

1. Be buildable out-of-tree using `./do`
2. Has a tiny patch to make it with with the WLM-20u2
3. Use your regulatory information instead of the info which is burned in the chip.
I trust you'll be honest and stay in bounds.

Protip: Default setting is "world" (ban every channel that's illegal in any country)
setting regulatory info to the country where you actually live will open up more channels.

## To use this

**STOP THIS IS A KERNEL MODULE PATCH, IT MIGHT KILL YOUR COMPUTER AND EAT YOUR CAT**

    ./do build
    ./do install

## To remove it

    ./do remove

## The actual patch... todo: upstream this at some point...

```patch
diff --git a/ath9k/hif_usb.c b/ath9k/hif_usb.c
index 6d5d716..0d6401a 100644
--- a/ath9k/hif_usb.c
+++ b/ath9k/hif_usb.c
@@ -56,6 +56,8 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
          .driver_info = AR9280_USB },  /* Sony UWA-BR100 */
        { USB_DEVICE(0x04da, 0x3904),
          .driver_info = AR9280_USB },
+       { USB_DEVICE(0x0930, 0x0A08),
+         .driver_info = AR9280_USB },  /* Toshiba WLM 20U2 */
 
        { USB_DEVICE(0x0cf3, 0x20ff),
          .driver_info = STORAGE_DEVICE },
```
