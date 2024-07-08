const std = @import("std");
const Suit = enum(u2) { Clubs, Diamonds, Hearts, Spades };
const Rank = enum(u4) { Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King };
const Card = packed struct {
    rank: Rank,
    suit: Suit,
    fn encode(card: @This()) u64 {
        return @as(u64, 1) << (@as(u6, @intFromEnum(card.suit)) * 13 + @as(u6, @intFromEnum(card.rank)));
    }

    // TODO: decode (string repr)
};

fn init_deck() u64 {
    var deck: u64 = 0;
    for (std.enums.values(Suit)) |suit| {
        for (std.enums.values(Rank)) |rank| {
            const card: Card = .{ .rank = rank, .suit = suit };
            deck |= card.encode();
            std.debug.print("DECK\t{any}\n", .{deck});
        }
    }

    return deck;
}

//TODO: shuffle deck
//TODO deal a card from top of deck

test "test" {
    const deck = init_deck();
    _ = deck;
}
