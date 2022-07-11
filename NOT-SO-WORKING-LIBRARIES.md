## THESE ARE THE LIBRARIES THAT CURRENTLY DO NOT BUILD WITHOUT ANY SOURCE CODE EDITING ( in alphabetical order :) )

-------------------------------------------------------------------------------------------------------------------

libffi - Has `--version-script` argument - Fix: Use sed to remove it from Makefiles - Will be pushed soon.

libmodplug - Has undefined symbols: `__chkstk`, `__rt_udiv64`, `__rt_sdiv`, `__rt_udiv`, and `__rt_sdiv64` - Fix: Use patches or sed to remove `-nostdlib` (why is this even here?) - Will be pushed soon.

libusb1 - Has `--add-stdcall-alias` argument - Fix: Use sed to remove it from Makefiles - Will be pushed soon.

libxml2 - Has `--version-script` argument - Fix: Use sed to remove it from Makefiles - Will be pushed soon.

pcre - Has undefined symbols: `__chkstk`, `__rt_udiv64`, and `__rt_sdiv64` - Fix: Use patches or sed to remove `-nostdlib` (why is this even here?) - Will be pushed soon.

tiff - Has undefined symbol: `__chkstk` - Fix: Use patches or sed to remove `-nostdlib` (why is this even here?) - Will be pushed soon.