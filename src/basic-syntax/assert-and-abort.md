# Assert and Abort

<!--

Chapter: Basic Syntax
Goal: Introduce abort keyword and `assert!` macro.
Notes:
    - previous chapter mentions constants
    - error constants standard ECamelCase
    - `assert!` macro
    - asserts should go before the main logic
    - Move has no catch mechanism
    - abort codes are local to the module
    - there are no error messages emitted
    - error codes should handle all possible scenarios in this module

Links:
    - constants (previous section)
 -->

## Abort

The `abort` keyword is used to abort the execution of a transaction. It is used in combination with an abort code, which will be returned to the caller of the transaction. The abort code is an integer of type `u64` and can be any value.

```move
let user_has_access = true;

// abort with a predefined constant if `user_has_access` is false
if (!user_has_access) {
    abort 0
};

// there's an alternative syntax using parenthesis`
if (user_has_access) {
   abort(0)
};

/* ... */
```

## assert!

The `assert!` macro is a built-in macro that can be used to assert a condition. If the condition is false, the transaction will abort with the given abort code. The `assert!` macro is a convenient way to abort a transaction if a condition is not met. The macro shortens the code otherwise written with an `if` expression + `abort`.

```move
// aborts if `user_has_access` is false with abort code 0
assert!(user_has_access, 0);

// expands into:
if (!user_has_access) {
    abort 0
};
```

## Error constants

To make error codes more descriptive, it is a good practice to define error constants. Error constants are defined as `const` declarations and are usually prefixed with `E` followed by a camel case name. Error constatns are no different from other constants and don't have special handling. So their addition is purely a practice for better code readability.

```move
/// Error code for when the user has no access.
const ENoAccess: u64 = 0;
/// Trying to access a field that does not exist.
const ENoField: u64 = 1;

// asserts are way more readable now
assert!(user_has_access, ENoAccess);
assert!(field_exists, ENoField);
```

## Better error handling

Whenever execution encounters an abort, transaction fails and abort code is returned to the caller. Move VM returns the module name that aborted the transaction and the abort code. This behavior is not fully transparent to the caller of the transaction, especially when a single function contains multiple calls to the same function which may abort. In this case, the caller will not know which call aborted the transaction, and it will be hard to debug the issue or provide meaningful error message to the user.

```move
module book::module_a {
    use book::module_b;

    public fun do_something() {
        let field_1 = module_b::get_field(1); // may abort with 0
        /* ... a lot of logic ... */
        let field_2 = module_b::get_field(2); // may abort with 0
        /* ... some more logic ... */
        let field_3 = module_b::get_field(3); // may abort with 0
    }
}
```

The example above illustrates the case when a single function contains multiple calls which may abort. If the caller of the `do_something` function receives an abort code `0`, it will be hard to understand which call to `module_b::get_field` aborted the transaction. To address this problem, there are common patterns that can be used to improve error handling.

### Rule 1: Handle all possible scenarios

It is considered a good practice to provide a safe "check" function that returns a boolean value indicating whether an operation can be performed safely. If the `module_b` provides a function `has_field` that returns a boolean value indicating whether a field exists, the `do_something` function can be rewritten as follows:

```move
module book::module_a {
    use book::module_b;

    const ENoField: u64 = 0;

    public fun do_something() {
        assert!(module_b::has_field(1), ENoField);
        let field_1 = module_b::get_field(1);
        /* ... */
        assert!(module_b::has_field(1), ENoField);
        let field_2 = module_b::get_field(2);
        /* ... */
        assert!(module_b::has_field(1), ENoField);
        let field_3 = module_b::get_field(3);
    }
}
```

By adding custom checks before each call to `module_b::get_field`, the developer of the `module_a` takes control over the error handling. And it allows implementing the second rule.

### Rule 2: Abort with different codes

The second trick, once the abort codes are handled by the caller module, is to use different abort codes for different scenarios. This way, the caller module can provide a meaningful error message to the user. The `module_a` can be rewritten as follows:

```move
module book::module_a {
    use book::module_b;

    const ENoFieldA: u64 = 0;
    const ENoFieldB: u64 = 1;
    const ENoFieldC: u64 = 2;

    public fun do_something() {
        assert!(module_b::has_field(1), ENoFieldA);
        let field_1 = module_b::get_field(1);
        /* ... */
        assert!(module_b::has_field(1), ENoFieldB);
        let field_2 = module_b::get_field(2);
        /* ... */
        assert!(module_b::has_field(1), ENoFieldC);
        let field_3 = module_b::get_field(3);
    }
}
```

Now, the caller module can provide a meaningful error message to the user. If the caller receives an abort code `0`, it can be translated to "Field 1 does not exist". If the caller receives an abort code `1`, it can be translated to "Field 2 does not exist". And so on.

Utilizing these two rules will make the error handling more transparent to the caller of the transaction.
