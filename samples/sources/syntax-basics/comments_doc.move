// Copyright (c) Damir Shamanaev 2023
// Licensed under the MIT License - https://opensource.org/licenses/MIT

/// Module has documentation!
module book::comments_doc {

    /// This is a 0x0 address constant!
    const AN_ADDRESS: address = @0x0;

    /// This is a struct!
    struct AStruct {
        /// This is a field of a struct!
        a_field: u8,
    }

    /// This function does something!
    /// And it's documented!
    fun do_something() {}
}
