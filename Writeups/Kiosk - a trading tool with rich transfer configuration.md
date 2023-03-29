Kiosk is a module in the Sui Framework which defines the `Kiosk` type - an object that is used to trade assets on Sui.

Kiosk can be created by anyone by calling the `kiosk::new(): (Kiosk, KioskOwnerCap)` method. The storage for the Kiosk can be defined by the creator, but it is intended to be used as a shared object.

Any item can be placed into a Kiosk by using `kiosk::place`, and then taken with `kiosk::take` function (\*unless it is "locked"). Once placed, an item can be traded if there's an existing and available `TransferPolicy` for this item.

---
By default, a type is not tradable in kiosks and requires a `TransferPolicy<T>` - an object that is used to authorize transfers for the type `T`. Creators can create a new transfer policy via the `transfer_policy::new<T>(Publisher): (TransferPolicy<T>, TransferPolicyCap)` call.






Pros:

- trading inventory at hand - besides basic "list" function, kiosk supports extensions such as auctions, games (rock paper scissors over an asset?), lotteries and more - anything that can be written in Move
- creator sets the rules - full control over policies enforced on trades; creators can choose to enforce royalties, remove them, add a fixed commission on top or require a retweet in an imaginary "sui twitter" application. Any set of any rules - including custom ones - can be added and removed at any time by creators for their types
- an agreement between traders and creators - no third party - creators decide which fees to apply and if restrictions are too tight, creators can choose to lower the royalty fee, remove any rule from the transfer policy. And all it takes is a single transaction
- strong policy is an option - creators can choose to "lock" their items in a Kiosk, so policies are enforced on all actions. Good news - if that's too much, the feature can be turned off at any moment
- no favorites - the interface is the same for any object, there're no exceptions or privileged types

Cons:

- discoverability - 
