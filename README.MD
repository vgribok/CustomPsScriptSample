# Overview

This is a special-purpose event handler script template.

To use it, please fork this repo and *modify event handler 
ps1 files* as directed below.

* To run your logic *at the end of system initialization*,
  modify [OnAfterInit.ps1](./src/OnAfterInit.ps1).

* To run your logic *after user logged in*,
  modify [OnAfterUserLogin.ps1](./src/OnAfterUserLogin.ps1).

You should not need to modify any other files except this one,
when committing your scripts.