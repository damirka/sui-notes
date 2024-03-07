# Importing Modules

<!--
Goals:
    - Show the import syntax
    - Local dependencies
    - External dependencies
    - Importing modules from other packages
 -->

Move achieves high modularity and code reuse by allowing module imports. Modules within the same package can import each other, and a new package can depend on already existing packages and use their modules too. This section will cover the basics of importing modules and how to use them in your own code.

## Importing a Module

Modules defined in the same package can import each other. The `use` keyword is followed by the module path, which consists of the package address (or alias) and the module name separated by `::`.

File: sources/module_one.move
```move
// File: sources/module_one.move
module book::module_one {
    /// Struct defined in the same module.
    public struct Character has drop {}

    /// Simple function that creates a new `Character` instance.
    public fun new(): Character { Character {} }
}
```

File: sources/module_two.move
```move
module book::module_two {
    use book::module_one; // importing module_one from the same package

    /// Calls the `new` function from the `module_one` module.
    public fun create_and_ignore() {
        let _ = module_one::new();
    }
}
```

<!-- TODO: add member import -->

## Adding an External Dependency

Every new package generated via the `sui` binary features a `Move.toml` file with a single dependency on the *Sui Framework* package. The Sui Framework depends on the *Standard Library* package. And both of these packages are available in default configuration. Package dependencies are defined in the [Package Manifest](./../concepts/manifest.md) as follows:

```toml
[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }
Local = { local = "../my_other_package" }
```

The `dependencies` section contains a list of package dependencies. The key is the name of the package, and the value is either a git import table or a local path. The git import contains the URL of the package, the subdirectory where the package is located, and the revision of the package. The local path is a relative path to the package directory.

If a dependency is added to the `Move.toml` file, the compiler will automatically fetch (and later refetch) the dependencies when building the package.

## Importing a Module from Another Package

Normally, packages define their addresses in the `[addresses]` section, so you can use the alias instead of the address. For example, instead of `0x2::coin` module, you would use `sui::coin`. The `sui` alias is defined in the Sui Framework package. Similarly, the `std` alias is defined in the Standard Library package and can be used to access the standard library modules.

To import a module from another package, you use the `use` keyword followed by the module path. The module path consists of the package address (or alias) and the module name separated by `::`.

```move
module book::imports {
    use std::string; // std = 0x1, string is a module in the standard library
    use sui::coin;   // sui = 0x2, coin is a module in the Sui Framework
}
```
