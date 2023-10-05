module 0x0::Gif {
use sui::transfer::{Self};
use sui::object::{Self, ID,UID};
use sui::tx_context::{Self,TxContext};
use std::string::{Self,String};
use std::vector;
use sui::event;

struct AddGifEvent has copy, drop {
    object_id: ID,
    sender: address,
    gif_link: String
}



struct Gif has key{
    id: UID,
    total_gif: u64,
    gif_list: vector<ItemStruct>
}
struct ItemStruct has store{
    gif_link: String,
    user_address: address
}

fun init(ctx: &mut TxContext) {
    let gif = Gif {
        id: object::new(ctx),
        total_gif: 0,
        gif_list: vector::empty()
    };
    transfer::share_object(gif);
}

public entry fun add_gif(gif_link: vector<u8>, gif: &mut Gif, ctx: &mut TxContext){
    let user = tx_context::sender(ctx);
    let item = ItemStruct{
        gif_link: string::utf8(gif_link),
        user_address: user
    };
    event::emit(AddGifEvent {
            object_id: object::uid_to_inner(&gif.id),
            sender: user,
            gif_link: item.gif_link,
        });
    vector::push_back(&mut gif.gif_list, item);
    gif.total_gif = gif.total_gif + 1;

}

}