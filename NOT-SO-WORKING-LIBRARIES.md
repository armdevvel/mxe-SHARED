## THESE ARE THE LIBRARIES THAT CURRENTLY DO NOT BUILD WITHOUT ANY SOURCE CODE EDITING ( in alphabetical order :) )

-------------------------------------------------------------------------------------------------------------------

Boost - Issue: Stupid variables as declspec import and export do not define correctly - Fix: No clue. I hate b2 / Boost's build system. - Bad Fix: Use static (already being done)

Epoxy / GTK+ 3 - Issue: Epoxy is a GL library | GTK+ 3 RELIES on Epoxy. - Fix: Remove GL dependencies from GTK+ 3. No clue when this will be pushed. - Bad Fix: Let it stay as it is (builds as STATIC (huge))