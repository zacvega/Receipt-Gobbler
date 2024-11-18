### Status

It works, though there are a few bugs. By default a cached response generated using the example Chiptole receipt is used instead of calling the real API. This behavior can be toggled by setting the `USE_MOCK_API_RESPONSE` at the top of `Receipt_GobblerApp.swift`. Data isn't persistently saved yet.

### Major TODOs, bugs to fix

* Bug: Adding multiple receipts will overwrite the previous one
* Feature: Persistently save data
