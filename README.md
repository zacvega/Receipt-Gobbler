### Status

It works, though there are a few bugs. By default a cached response generated using the example Chiptole receipt is used instead of calling the real API. This behavior can be toggled by setting the `USE_MOCK_API_RESPONSE` at the top of `Receipt_GobblerApp.swift`.

As of 2c18337 data is persistently stored by dumping it to a JSON file.

### Major TODOs, bugs to fix

See https://github.com/zacvega/Receipt-Gobbler/issues

### Xcode tips

* Debugging on/off toggle: The app launches much faster with debugging turned off. Toggle debugging off temporarily if you just want to test functionality, not debug the code. 
    * Xcode toolbar -> Product -> Scheme -> Edit Scheme -> Check/uncheck "Debug executable"
