# Clock

Sui features a native way of fetching the current time with millisecond precision. This is useful for time-based logic, such as locking or enabling behaviors at certain times. The clock can also be used a source of pseudo-randomness, however, [there are better ways to generate random numbers](./randomness.md).

- module: `sui::clock`
- main type: `sui::clock::Clock`

Clock is a unique [shared object](./shared-object.md) on Sui with predefined address `0x6`. It can used as an immutable transaction input, however, using it as a mutable transaction input will cause the transaction to fail.

## Usage

The `clock` module can be imported from the [Sui Framework](./sui-framework.md).

```move
module examples::clock {
    use sui::object::{Self, UID};
    use sui::clock::{Self, Clock};
    use sui::tx_context::TxContext;

    /// A dummy struct that hold the time it was created.
    struct Timestamp has key, store {
        id: UID,
        timestamp: u64,
    }

    /// Creates a new `Timestamp` Object using the `Clock`.
    public fun new(clock: &Clock, ctx: &mut TxContext): Clock {
        Timestamp {
            id: object::new(ctx),
            timestamp: clock::timestamp_ms(clock)
        }
    }
}
```
