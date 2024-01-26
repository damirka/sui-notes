# Package Manifest

The `Move.toml` file is a manifest file that describes the project and its dependencies. It has the following structure (varies depending on the network):

```toml
[package]
name = "my_project"
version = "0.0.0"

[dependencies]
MoveStdlib = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib", rev = "main" }

[addresses]
std =  "0x1"
```

Each section can have multiple fields, and some of them are optional.

- `[package]` section describes the project metadata. It supports the following fields:
  - `name` - the name of the project. It should be unique within the network.
  - `description` - the description of the project.
  - `version` - the version of the project. It should be unique within the network.
  - `authors` - the list of authors of the project.

- `[dependencies]` section describes the project dependencies. Each dependency should have a name and a git repository URL (or a path to the local directory). Each

- `[addresses]` section adds aliases for the addresses. Any address can be specified in this section, and then used in the code as an alias. For example, if you add `std = "0x1"` to this section, you can use `0x1` as `std` in the code.

- `[dev-addresses]` - the same as `[addresses]`, but only works for the test and dev modes.

- `[dev-dependencies]` - the same as `[dependencies]`, but only works for the test and dev modes.

## Further reading

- [Packages in the Move Documentation](https://move-language.github.io/move/packages.html)
