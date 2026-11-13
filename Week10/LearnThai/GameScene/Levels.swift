//
//  Levels.swift
//  LearnThai
//
//    .  floor (walkable)
//    #  wall (blocked)
//    N  NPC — blocked; tap them to walk over and talk
//    S  seat — tap to walk there and sit down
//    ?  door — tap to walk there and go to another level
//
//  NPCs and doors need extra info, so they're listed separately in
//  READING ORDER (left → right, top line → bottom line):
//  the 1st N in the layout uses npcs[0], the 2nd N uses npcs[1], etc.
//  same for ? and doors.
//

import Foundation

struct NPC {
    let name: String
    let lines: [String] // tapping them again goes to the next line
    var sprite: String? = nil // image set name in Assets.xcassets (orange square if nil/missing)
    var height: Double = 0.9  // sprite height in tiles; stands on the bottom of its tile and grows upward
}

struct Level {
    let name: String       // used by doors to point at this level
    let mapImage: String   // image set name in Assets.xcassets (hidden if it doesn't exist)
    let layout: [String]
    var npcs: [NPC] = []
    var doors: [String] = [] // level name each ? leads to
}

let startLevel = "room"

let levels: [String: Level] = [
    "room": Level(
        name: "room",
        mapImage: "map",
        layout: [
            "#######",
            "#..N..#",
            "#.....#",
            "#.....#",
            "#.....#",
            "#.....#",
            "###?###",
        ],
        npcs: [
            NPC(name: "Mali", lines: [
                "สวัสดีค่ะ\nsà-wàt-dee khâ\nHello!",
                "สบายดีไหม\nsà-baai dee mǎi?\nHow are you?",
                "ลาก่อน\nlaa gòn\nGoodbye!",
            ], sprite: "npc_bear", height: 1.5),
        ],
        doors: ["street"]
    ),

    "street": Level(
        name: "street",
        mapImage: "street", // add an image set called "street" to give it art
        layout: [
            "...?...",
            ".......",
            ".#...#.",
            ".......",
            "..N....",
            ".....S.",
            ".......",
        ],
        npcs: [
            NPC(name: "Somchai", lines: [
                "สวัสดีครับ\nsà-wàt-dee khráp\nHello!",
                "ขอบคุณครับ\nkhàwp-khun khráp\nThank you!",
            ]),
        ],
        doors: ["room"]
    ),
]
