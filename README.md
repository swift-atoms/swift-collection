# swift-collection

## Prefix integration

The default-enabled `Prefix` trait supplies this package's interpretation of the
independent prefix selectors from swift-prefix. Use this package's library product;
no separate integration product is required.

`end(inCollection:)` borrows custom collections to select a boundary. These APIs
moved from the retired Prefix Collection product into Collection; import Collection
to use them. Prefix itself no longer depends on Collection or Iterator.
