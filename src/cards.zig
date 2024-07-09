const std = @import("std");
const Suit = enum(u2) { Clubs, Diamonds, Hearts, Spades };
const Rank = enum(u4) { Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King };
const Deck = u64;
const Card = packed struct {
    rank: Rank,
    suit: Suit,
    fn encode(card: @This()) u64 {
        return @as(u64, 1) << (@as(u6, @intFromEnum(card.suit)) * 13 + @as(u6, @intFromEnum(card.rank)));
    }
    fn debug(card: @This()) void {
        std.debug.print("{s} of {s} ", .{ @tagName(card.rank), @tagName(card.suit) });
    }

    fn pretty(card: @This()) void {
        std.debug.print("\n_________________\n", .{});
        std.debug.print("|\t\t|\n", .{});
        std.debug.print("|{s}\t{s}\t|\n", .{ @tagName(card.suit), @tagName(card.rank) });
        var i: usize = 0;
        while (i < 8) : (i += 1) {
            std.debug.print("|\t\t|\n", .{});
        }
        std.debug.print("|{s}\t{s}\t|\n", .{ @tagName(card.rank), @tagName(card.suit) });
        std.debug.print("|_______________|\n", .{});
    }
};

fn init() Deck {
    var deck: Deck = 0;
    for (std.enums.values(Suit)) |suit| {
        for (std.enums.values(Rank)) |rank| {
            const card: Card = .{ .rank = rank, .suit = suit };
            deck |= card.encode();
        }
    }

    return deck;
}

fn deal(deck: *Deck) ?Card {
    if (deck.* == 0) return null;
    const ctz: u64 = @ctz(deck.*);
    const bit: u64 = @as(u64, 1) << @intCast(ctz);
    const rank: u4 = @intCast(ctz % 13);
    const suit: u2 = @intCast(ctz / 13);
    const card: Card = .{ .rank = @enumFromInt(rank), .suit = @enumFromInt(suit) };
    deck.* ^= bit;
    return card;
}

//TODO: shuffle deck

test "test" {
    var deck = init();
    var i: usize = 0;
    while (i < 52) : (i += 1) {
        const card = deal(&deck);
        if (card) |c| {
            if (i % 13 == 0) {
                c.pretty();
            } else {
                c.debug();
            }
        }
    }
}
