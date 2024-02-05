# Struct Methods

Move Compiler supports *receiver syntax*, which allows defining methods which can be called on instances of a struct. This is similar to the method syntax in other programming languages. It is a convenient way to define functions which operate on the fields of a struct.

## Method syntax

If the first argument of a function is a struct internal to the module, then the function can be called using the `.` operator. If the function uses a struct from another module, then method won't be associated with the struct by default. In this case, the function can be called using the standard function call syntax.

When a module is imported, the methods are automatically associated with the struct.

```move
module book::method_syntax {
    /// A struct representing a hero.
    struct Hero has drop {
        health: u8,
        mana: u8,
    }

    /// Create a new Hero.
    public fun new(): Hero { Hero { health: 100, mana: 100 } }

    /// A method which casts a spell, consuming mana.
    public fun heal_spell(hero: &mut Hero) {
        hero.health = hero.health + 10;
        hero.mana = hero.mana - 10;
    }

    /// A method which returns the health of the hero.
    public fun health(hero: &Hero): u8 { hero.health }

    /// A method which returns the mana of the hero.
    public fun mana(hero: &Hero): u8 { hero.mana }

    #[test]
    // Test the methods of the `Hero` struct.
    fun test_methods() {
        let mut hero = new();
        hero.heal_spell();

        assert!(hero.health() == 110, 1);
        assert!(hero.mana() == 90, 2);
    }
}
```

## ...
