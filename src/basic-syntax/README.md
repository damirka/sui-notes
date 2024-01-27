<!--


    This is an attempt to structure the narrative in a way that makes sense, and so that it builds
    up to the next section.

    Then why would we give "The first Move section" ?
        - it's great to give a taste of Move overall, without linking it to storage / specific blockchain
        - maybe it can be confusing; though if we call the first section "Hello Move", and the second
          "Hello Sui", then the reader would differentiate between the two
        // marking the above as an open question for now



    Introduction

    Foreword
        - this book is a product of collaboration between people who love Move and
          education and people who are incredibly smart and build the language

    What is Sui

    Setting Up the Environment
        - Install Sui
        - Set up your IDE
        - Project Setup         ??? not sure about this one
        - Manifest              ??? this one is also not sure

    Your First Move
        // goal: showcase main features of the CLI / compiler
        // note: this section is not about Sui, but about Move; it is interactive and
                can be run by anyone to get a taste of Move as a language and Sui CLI
                as a tool; it's pretty neat that Move has tests, and that there's a
                documentation generator, and that there's a way to debug the code;






 -->

# Basic Syntax

Before we get to the part that is the most exciting about Sui, we need to learn some basics. In this section, we will learn about the basic syntax of the Move language, setting the foundation for the rest of the book.

## Code Organization

The base unit of code organization in Move is a package. A package is a collection of modules. A module is a collection of functions, types, and other items. A package is published on the blockchain as a single unit. A package can be imported by other packages.

```
package 0x...
    module a
        struct A1
        struct A2
    module b
```

> ### Remember
> - Package is published and identified via an address, eg `0x0`.
> - Modules are accessed via a path, eg `0x0::module`.
> - Module members are accessed via a path, eg `0x0::module::member`.

Given that there can be only one module member with a given name, the path `0x0::module::member` is unique and can be used to access the member. The path `0x0::module` is also unique and can be used to access the module. The path `0x0` is also unique and can be used to access the package.

Package consists of modules - separate scopes that contain functions, types, and other items. Modules can import and use other modules, and modules placed in the same package may have special access to each other.

## Address

Addresses mark the location of objects in the blockchain. On Sui, an address is a 32-byte value. Addresses are used to identify packages and objects. Addresses are written in hexadecimal notation, eg `0x0`.

## Package Structure

A package is a directory with a `Move.toml` file and a `sources` directory. The `Move.toml` file contains metadata about the package, and the `sources` directory contains the source code of the package. On Sui, the package manifest usually looks like this:

```toml
[package]
name = "book"
edition = "2024.alpha"

[dependencies]
Sui = {
    git = "https://github.com/MystenLabs/sui.git",
    subdir = "crates/sui-framework/packages/sui-framework",
    rev = "framework/testnet"
}

[addresses]
book = "0x0"
```

The `name` field contains the name of the package. It is not a published name, but a name of the package when it is imported by other packages. The `edition` field contains the edition of the Move language, the "2024" edition is the most recent one. The `dependencies` section contains package dependencies. To run meaningful applications on Sui, you need to have the `Sui` package as a dependency.

The addresses section contains named aliases for addresses. Not yet published package always has the address `0x0`, but when it is published, the address should be changed to the actual address. Compiler will replace the aliases with the actual addresses when compiling the package.

<!-- This is a good example for why the book format is great -->

For convenience and readability, addresses section should contain at least one alias for the package address. It allows you to use the alias instead of the address when you need to access the package; it also splits the configuration and code, allowing you to change the value in one place. For example, instead of `0x0::module::member` you can use `book::module::member`.

Package is imported with its addresses - the `Sui` import will add `sui` and `std` aliases. They're standard aliases for Sui Framework - 0x2, and Standard Library - 0x1.

## Module

While package can be considered an organizational unit, module is where the code lives. Module is a collection of functions, types, constants and other items. Module is declared with the `module` keyword:

```Move
module book::my_module {

}
```

The module declaration consists of the `module` keyword followed by the module path - a package address and a module name separated by `::`. The module path is followed by the module body - a collection of items inside curly braces `{}`. The module body is a scope, and all items inside it are inaccesible from outside the module by default.

Modules are stored in the `sources` directory (and its subdirectories). File system path doesn't affect the module path and will be omitted when publishing, so the module path is `book::my_module` regardless of the file system path. For example, if you have a directory structure like this:

```
sources/
    basics/
        my/
            module.move
Move.toml
```

The module path will be `book::my_module`, and **not** `book::basics::my::module`.

Modules can import other modules and access public functions and types. The dependency needs to be declared in the package manifest, so that the compiler knows where to find it. We will learn more about imports in the [Import](../syntax-basics/import.md) section.

Directories other than `sources` will not be compiled by default and hence won't be published. You can use them to store tests, documentation, examples, and other files. Though all folders are scanned when compiling in "test mode", so examples and tests can be checked for compilation errors.

Modules compiled in test mode won't be published, so there's no way to make a mistake publishing what wasn't meant to be published.

## Interaction with the blockchain

Function is a block of code that contains a sequence of statements and expressions. Function can take arguments and return a value. Function is declared with the `fun` keyword.

```Move
module book::my_module {
    fun my_function() {}
}
```

Like any module member, functions are accessed via a path. The path consists of the module path and the function name separated by `::`. For example, if you have a function called `my_function` in the `my_module` module in the `book` package, the path to it will be `book::my_module::my_function`.

Functions can be called in a transaction. User can send a transaction containing a call to a function, and the function will be executed on the blockchain. We will learn more about transactions in the [Transaction](../syntax-basics/transaction.md) section. Any public function can be called in a transaction.

So, if we made the `my_function` public, we can call it in a transaction:

```Move
module book::my_module {
    public fun my_function() {}
}
```

To call it, a user would need to send a transaction containing a "move-call", which would roughly look like this:

```bash
sui client call \
    --package 0x... \
    --module book::my_module \
    --function my_function \
    --gas-budget 10000000
```

Having said that, Move modules define the interface of the package. For example, if there's a need to implement a database-like system with addition, modification and deletion of records, the module would define a matching set of functions. And users would be able to call those functions in transactions.

## Storage

Move is an object-oriented language, and as such, it stores data in objects. Objects are instances of types with the `key` ability and are stored in the blockchain storage. Every Object has a `UID` - a unique identifier that is used to access the object. The `UID` is a 32-byte value, and it is generated when the object is created. The internal value of the UID also contains an address.

> Package is also an immutable (unchangeable) object stored in the blockchain storage. However, it is a special case, and can't be used to store data except for the package bytecode.

## Accounts

Accounts are the main way to interact with the blockchain. Accounts are identified by addresses and can send transactions to the blockchain. An account is generated from a private key, and the private key is used to sign transactions. Every account has a standard 32-byte address.

Every transaction has a sender - an account that signed the transaction. The sender is identified by their address. Accounts can own objects

## End to end example

<!--
    After we explained the basics of the code organization. I think it makes sense to give an example,
    Rust Book does it. It's a good way to show how the code is organized and how it works. And it will
    leave the reader with something to play with.

    So that when we get to the next section, they will be able to modify the code and see how it works.
    And it will be a good way to introduce the next section.

    The example should be simple and short. It should be something that can be explained in a few
    sentences. It should be something that can be modified and played with. It should be something
    that can be used as a base for the next section.

    Maybe that's the point where we introduce objects and storage? They won't appear any time soon, but
    some bits can be illustrated upfront to create this anticipation for what is possible.
-->

## Getting Ready

Now that we know what a package, account and storage are, let's get to the basics and learn to write some code.

This section covers:

- types
- functions
- structs
- constants
- control flow
- tests


## Primitive types and variables

<!--
    We know the basics of the package, module and function.
    Now we can introduce the function body and variables.

    How to make it interactive so that people can try it out? Not even run it per se but give them enough so they can get excited and play with it themselves. Maybe a playground?

    And which features of the language can make gears in their heads start turning? Maybe the ability to create a struct and store it in the storage? Or maybe the ability to create a function and call it in a transaction? Or maybe the ability to create a test and run it? All of these are legit.


-->

Move has a set of primitive types that are built into the language. They are the building blocks of the language and are used to build more complex types. The primitive types are:

- `bool` - boolean type, can be either `true` or `false`.
- integers - unsigned integers of different sizes: `u8`, `u16`, `u32`, `u64`, `u128`, `u256`
- `address` - address type, represents a location in the blockchain
- `vector` - vector type, represents a dynamic array of elements of the same type

The first three types are primitive types, and the last one is a composite type. We will learn more about composite types in the [Composite Types](../syntax-basics/composite-types.md) section.

## Bool

The `bool` type represents a boolean value. It can be either `true` or `false`. The `bool` type is used to represent a condition in control flow statements. For example, the `if` statement takes a `bool` value and executes the code inside the body if the value is `true`:

```Move
module book::my_module {
    fun my_function() {
        if (true) {
            // this code will be executed
        }
    }
}
```
