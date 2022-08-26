## THESE ARE THE LIBRARIES THAT CURRENTLY DO NOT BUILD AS SHARED WITHOUT ANY SOURCE CODE EDITING ( in alphabetical order :) )

-------------------------------------------------------------------------------------------------------------------

Boost - Issue: Stupid variables as declspec import and export do not define correctly - Fix: No clue. I hate b2 / Boost's build system. - Bad Fix: Use static (already being done).

GTK+ 2 - Issue: Apparently forced to build as static, but when set to build as shared, some error occurs. - Fix: Can't remember, will mess with it later.

libvpx - Issue: Builds as static - Possible Fix: See if upgrading fixes.

pdcurses - Issue: Builds as static - Fix: Enable DLL building, will do later.

PostgreSQL - Issue: Unsure - Fix: Unsure.