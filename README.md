# swift-collection

The default-enabled Repetition trait executes Cardinal count ranges and bounded
Predicate repetition. The Search trait finds complete matches and projects their
start or end boundary. These integrations support Swift collections and the
custom Collection protocol, with no dependency on swift-prefix.

Boundary selection does not consume input; parser adapters commit after successful
selection. Slice-returning operations avoid materializing arrays. Custom collection
boundary selection can borrow noncopyable sources; owned slice results retain the
existing collection slice ownership restrictions.
