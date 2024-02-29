# Object Model

<!--

- now objects?
    - Sui does not have global storage
    - storage is split into a pool of objects
    - objects are identified by a 32-byte value
    - objects are stored in the blockchain storage
    - focus on infrastructure properties of objects

 -->

Sui does not have global storage. Instead, storage is split into a pool of objects. Some of the objects are owned by accounts and available only to them, and some are *shared* and can be accessed by anyone on the network. There's also a special kind of *shared immutable* objects, also called *frozen*, which can't be modified, and act as public chain-wide constants.

Each object has a unique 32-byte identifier - UID, it is used to access and reference the object.

<!--

    - UID is also an address
    - Object has an owner field which can be w`shared`, `account_address`, `object_owner` or `immutable`.
    - Object has a version which acts as a nonce - hence Sui does not require an account nonce
    - Object has a Move type with the `key` ability

 -->
