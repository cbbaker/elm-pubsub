# elm-pubsub
An Elm effect module that allows components to subscribe to channels and publish messages to them.

My first elm app had a needsRefresh method for every message type, so it could figure out when to reload data from the API. When I added websockets, I ripped out all the needsRefresh code, since I was getting updates pushed from the server whenever I did anything. Then, when I tried to add off-line support, I realized that the easiest way to send messages between components in elm was to round-trip them through an echo server.

This effect module has the same API as the websocket module, but it bypasses the server. The example application has a button which sends a message to a sibling component, which displays a message.
