// Copyright (c) Damir Shamanaev 2023
// Licensed under the MIT License - https://opensource.org/licenses/MIT

#[allow(lint(self_transfer, custom_state_change))]
module book::postcard {
    use std::string::String;
    use sui::tx_context::TxContext;
    use sui::object::{Self, UID};
    use sui::transfer;

    /// The PostCard object.
    public struct PostCard has key, store {
        /// The unique identifier of the Object.
        id: UID,
        /// The message to be printed on the gift card.
        message: String,
    }

    /// Create a new PostCard with a message.
    public fun new(message: String, ctx: &mut TxContext): PostCard {
        PostCard {
            id: object::new(ctx),
            message,
        }
    }

    /// Send the PostCard to the specified address.
    public fun send(card: PostCard, to: address) {
        transfer::transfer(card, to)
    }

    /// Keep the PostCard for yourself.
    public fun keep(card: PostCard, ctx: &TxContext) {
        transfer::transfer(card, tx_context::sender(ctx))
    }

    #[test]
    /// A silly test - create a new PostCard and keep it.
    fun create_and_send() {
        let card = new(string::utf8(b"Hello, Sui!"));
        let ctx = &mut tx_context::dummy();

        card.keep(card, ctx);
    }
}
