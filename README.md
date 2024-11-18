### Status

It works, though there are a few bugs. By default a cached response generated using the example Chiptole receipt is used instead of calling the real API. This behavior can be toggled by setting the `USE_MOCK_API_RESPONSE` at the top of `Receipt_GobblerApp.swift`. Data isn't persistently saved yet.

### Major TODOs, bugs to fix

* Bug: Adding multiple receipts will overwrite the previous one
* Feature: Persistently save data

### Xcode tips

* Debugging on/off toggle: The app launches much faster with debugging turned off. Toggle debugging off temporarily if you just want to test functionality, not debug the code. 
    * Xcode toolbar -> Product -> Scheme -> Edit Scheme -> Check/uncheck "Debug executable"
