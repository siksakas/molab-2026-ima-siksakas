//
//  GameScene.swift
//  LearnThai
//
//  Created by Siksaka Suriyasat on 11/5/26.
//

import SpriteKit

// one square on the board
// Hashable so it can go in a Set / be a Dictionary key (needed for walls + pathfinding)
struct GridCell: Hashable {
    var row: Int
    var col: Int
}

class GameScene: SKScene {
    let gridSize = 7
    let padding: CGFloat = 0 // gap between grid and screen edge

    let player = SKSpriteNode(color: .systemBlue, size: CGSize(width: 40, height: 40))

    // background map image — swapped per level (see Levels.swift)
    let map = SKSpriteNode(color: .clear, size: .zero)

    // holds all the tiles so we can wipe + rebuild them when the screen size changes
    let board = SKNode()

    // holds the NPC sprites (rebuilt with the board)
    let actors = SKNode()

    // computed from the screen size so all 7 tiles always fit
    var tileSize: CGFloat = 64

    // MARK: - Level
    // the layouts themselves are in Levels.swift

    // turn on to tint special tiles so you can line them up with your map art:
    // red = wall, blue = seat, green = door
    //ENABLE / DISABLE VISUAL CLIPPING HERE
    let showTileTypes = false

    var levelName = ""
    var blocked: Set<GridCell> = []        // walls + NPCs
    var seats: Set<GridCell> = []
    var doors: [GridCell: String] = [:]    // door tile → level it leads to
    var npcs: [GridCell: NPC] = [:]
    var npcNodes: [GridCell: SKSpriteNode] = [:]
    var npcLineIndex: [GridCell: Int] = [:] // which line each NPC says next

    // in bounds and not a wall/NPC — you can stand here
    func isOpen(_ cell: GridCell) -> Bool {
        (0..<gridSize).contains(cell.row) && (0..<gridSize).contains(cell.col) && !blocked.contains(cell)
    }

    // ok to walk *through* on the way somewhere else.
    // seats and doors only count if they're where you're going
    // (so you don't sit down or leave the level by accident).
    func canPassThrough(_ cell: GridCell) -> Bool {
        isOpen(cell) && !seats.contains(cell) && doors[cell] == nil
    }

    // MARK: - Movement tuning
    // all in tiles so it feels the same on every screen size.
    // play with these to change the feel.
    let maxSpeedTiles: CGFloat = 2.5   // top walking speed (tiles per second)
    let accelTiles: CGFloat = 6        // how fast it speeds up — lower = heavier
    let brakeTiles: CGFloat = 5        // how hard it can slow down — lower = slides further

    // MARK: - Movement state
    var currentCell = GridCell(row: 0, col: 0) // last tile we fully reached
    var route: [GridCell] = []           // tiles still to walk through, in order
    var moveSpeed: CGFloat = 0           // current speed in points/sec ("speed" is already taken by SKScene)
    var heading = CGVector(dx: 0, dy: 0) // direction we're currently walking
    var lastUpdateTime: TimeInterval = 0

    var talkTarget: GridCell?            // NPC to talk to once we arrive
    var isSitting = false
    var isChangingLevel = false          // ignore taps during the fade

    // just for the walking animation
    var walkPhase: CGFloat = 0
    var tilt: CGFloat = 0
    var sitAmount: CGFloat = 0           // 0 standing … 1 sat down (eased)

    weak var speechBubble: SKNode?

    // override bc we are overriding the existing didMove function in SKScene
    override func didMove(to view: SKView) {
        backgroundColor = .systemGray6

        // by default is at (0,0) we are moving the origin to center
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // lower zPosition = drawn first = further back, so the map sits under the tiles
        map.zPosition = -1
        addChild(map)

        addChild(board)
        addChild(actors)

        player.zPosition = 10
        addChild(player)

        loadLevel(startLevel, arrivingFrom: nil)
    }

    // with .resizeFill the scene size changes to match the view (and on rotation),
    // so rebuild the grid whenever that happens
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        guard view != nil else { return }
        layoutBoard()
    }

    // reads a level's layout and puts the player in it
    func loadLevel(_ name: String, arrivingFrom previous: String?) {
        guard let level = levels[name] else {
            print("⚠️ no level called \"\(name)\" in Levels.swift")
            return
        }
        levelName = name

        blocked = []; seats = []; doors = [:]; npcs = [:]; npcLineIndex = [:]
        var doorCount = 0, npcCount = 0

        for (line, text) in level.layout.enumerated() {
            let row = gridSize - 1 - line // flip: first line is the top
            for (col, ch) in text.enumerated() {
                let cell = GridCell(row: row, col: col)
                switch ch {
                case "#":
                    blocked.insert(cell)
                case "S":
                    seats.insert(cell)
                case "?":
                    if doorCount < level.doors.count {
                        doors[cell] = level.doors[doorCount]
                    } else {
                        doors[cell] = "" // still a door, just goes nowhere yet
                        print("⚠️ \(name): ? #\(doorCount + 1) has no entry in doors")
                    }
                    doorCount += 1
                case "N":
                    blocked.insert(cell) // can't walk through people
                    if npcCount < level.npcs.count {
                        npcs[cell] = level.npcs[npcCount]
                    } else {
                        npcs[cell] = NPC(name: "???", lines: ["..."])
                        print("⚠️ \(name): N #\(npcCount + 1) has no entry in npcs")
                    }
                    npcCount += 1
                default:
                    break
                }
            }
        }

        // background art — hide it if the image doesn't exist (instead of a red X)
        if let image = UIImage(named: level.mapImage) {
            map.texture = SKTexture(image: image)
            map.isHidden = false
        } else {
            map.isHidden = true
        }

        // spawn on the door that leads back where we came from, else near the middle
        let backDoor = doors.first { $0.value == previous && previous != nil }?.key
        currentCell = backDoor ?? nearestFreeCell(to: GridCell(row: gridSize / 2, col: gridSize / 2))

        route = []
        moveSpeed = 0
        talkTarget = nil
        isSitting = false
        sitAmount = 0
        speechBubble?.removeFromParent()

        layoutBoard()
    }

    func nearestFreeCell(to target: GridCell) -> GridCell {
        var best = target, bestDist = Int.max
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let c = GridCell(row: row, col: col)
                let d = abs(c.row - target.row) + abs(c.col - target.col)
                if canPassThrough(c) && d < bestDist { best = c; bestDist = d }
            }
        }
        return best
    }

    func layoutBoard() {
        // fit the grid inside the smaller side of the screen
        let available = min(size.width, size.height) - padding * 2
        tileSize = floor(available / CGFloat(gridSize))

        // stretch the map to cover exactly the 7x7 grid, centered at (0,0)
        let boardWidth = tileSize * CGFloat(gridSize)
        map.size = CGSize(width: boardWidth, height: boardWidth)
        map.position = .zero

        board.removeAllChildren()

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let cell = GridCell(row: row, col: col)
                let tileColor: UIColor = (row + col).isMultiple(of: 2)
                    ? .systemGray5 : .white

                let tile = SKSpriteNode(
                    color: tileColor,
                    size: CGSize(width: tileSize, height: tileSize)
                )
                tile.position = positionFor(cell)
                // see-through so the map shows underneath (0 = invisible, 1 = solid)
                tile.alpha = 0.3

                if showTileTypes {
                    if blocked.contains(cell) && npcs[cell] == nil {
                        tile.color = .systemRed; tile.alpha = 0.45
                    } else if seats.contains(cell) {
                        tile.color = .systemBlue; tile.alpha = 0.35
                    } else if doors[cell] != nil {
                        tile.color = .systemGreen; tile.alpha = 0.45
                    }
                }

                //acc adds tile to map
                board.addChild(tile)
            }
        }

        // NPCs — their sprite if they have one (else an orange square), with their name on top
        actors.removeAllChildren()
        npcNodes = [:]
        for (cell, npc) in npcs {
            let node: SKSpriteNode
            if let name = npc.sprite, let image = UIImage(named: name) {
                // npc.height tiles tall, keeping the image's shape,
                // feet on the bottom edge of the tile so taller sprites grow upward
                let h = tileSize * CGFloat(npc.height)
                node = SKSpriteNode(texture: SKTexture(image: image),
                                    size: CGSize(width: h * image.size.width / image.size.height, height: h))
                node.anchorPoint = CGPoint(x: 0.5, y: 0)
                node.position = positionFor(cell)
                node.position.y -= tileSize / 2
            } else {
                node = SKSpriteNode(color: .systemOrange,
                                    size: CGSize(width: tileSize * 0.625, height: tileSize * 0.625))
                node.position = positionFor(cell)
            }
            node.zPosition = 9

            let label = SKLabelNode(text: npc.name)
            label.fontName = "Thonburi-Bold"
            label.fontSize = tileSize * 0.2
            label.fontColor = .black
            // just above the top of the sprite, whatever its anchor
            label.position = CGPoint(x: 0, y: node.size.height * (1 - node.anchorPoint.y) + tileSize * 0.05)
            node.addChild(label)

            actors.addChild(node)
            npcNodes[cell] = node
        }

        // keep the player proportional to the tiles, on whatever tile it was standing on
        player.size = CGSize(width: tileSize * 0.625, height: tileSize * 0.625)
        player.position = positionFor(currentCell)
    }

    // converts a grid cell to a point in the scene.
    // offset is half the grid (3 tiles for a 7x7) so tile (3,3) lands at (0,0)
    func positionFor(row: Int, col: Int) -> CGPoint {
        let offset = CGFloat(gridSize - 1) / 2 * tileSize
        return CGPoint(
            x: CGFloat(col) * tileSize - offset,
            y: CGFloat(row) * tileSize - offset
        )
    }

    func positionFor(_ cell: GridCell) -> CGPoint {
        positionFor(row: cell.row, col: cell.col)
    }

    // the opposite of positionFor: which tile is this point on? (nil if off the board)
    func cellAt(_ point: CGPoint) -> GridCell? {
        let offset = CGFloat(gridSize - 1) / 2 * tileSize
        let col = Int(((point.x + offset) / tileSize).rounded())
        let row = Int(((point.y + offset) / tileSize).rounded())
        guard (0..<gridSize).contains(row), (0..<gridSize).contains(col) else { return nil }
        return GridCell(row: row, col: col)
    }

    // MARK: - Input

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isChangingLevel,
              let touch = touches.first,
              let cell = cellAt(touch.location(in: self)) else { return }

        if npcs[cell] != nil {
            approachNPC(at: cell)
        } else {
            walk(to: cell)
        }
    }

    func walk(to destination: GridCell) {
        // already walking: finish the step into the tile we're heading to,
        // then go from there (no teleporting or instant direction flips)
        let start = route.first ?? currentCell

        guard isOpen(destination),
              let path = findPath(from: start, to: destination) else {
            showTapMarker(at: destination, color: .systemRed) // can't go there
            return
        }

        talkTarget = nil
        setRoute(path)
        showTapMarker(at: destination, color: .white)
    }

    // walk to whichever tile next to the NPC is closest, then talk
    func approachNPC(at npcCell: GridCell) {
        let start = route.first ?? currentCell

        // already standing next to them? just talk
        if route.isEmpty && isNeighbor(currentCell, npcCell) {
            talk(to: npcCell)
            return
        }

        var best: [GridCell]?
        for (dr, dc) in neighborOffsets {
            let spot = GridCell(row: npcCell.row + dr, col: npcCell.col + dc)
            guard canPassThrough(spot), let path = findPath(from: start, to: spot) else { continue }
            if best == nil || path.count < best!.count { best = path }
        }

        guard let path = best else {
            showTapMarker(at: npcCell, color: .systemRed) // can't reach them
            return
        }

        talkTarget = npcCell
        setRoute(path)
        showTapMarker(at: npcCell, color: .white)
        if route.isEmpty { arrived() } // we were already on the right tile
    }

    func setRoute(_ path: [GridCell]) {
        route = route.first.map { [$0] + path } ?? path
        if !route.isEmpty { isSitting = false } // stand up
    }

    let neighborOffsets = [(1,0), (-1,0), (0,1), (0,-1), (1,1), (1,-1), (-1,1), (-1,-1)]

    func isNeighbor(_ a: GridCell, _ b: GridCell) -> Bool {
        a != b && abs(a.row - b.row) <= 1 && abs(a.col - b.col) <= 1
    }

    // shortest walkable route from start to end (not including start), or nil if walled off.
    // this is Dijkstra's algorithm: keep expanding the closest unvisited tile until we hit the end.
    func findPath(from start: GridCell, to end: GridCell) -> [GridCell]? {
        if start == end { return [] }

        var cost: [GridCell: CGFloat] = [start: 0]
        var cameFrom: [GridCell: GridCell] = [:]
        var open: Set<GridCell> = [start]

        while !open.isEmpty {
            // cheapest tile we haven't expanded yet (grid is tiny, so a simple scan is fine)
            let current = open.min { cost[$0]! < cost[$1]! }!
            open.remove(current)

            if current == end {
                // walk the breadcrumbs backwards to build the route
                var path = [end]
                while let prev = cameFrom[path[0]], prev != start {
                    path.insert(prev, at: 0)
                }
                return path
            }

            for (dr, dc) in neighborOffsets {
                let next = GridCell(row: current.row + dr, col: current.col + dc)
                // seats/doors are fine as the destination, but not as a shortcut
                guard next == end ? isOpen(next) : canPassThrough(next) else { continue }

                let diagonal = dr != 0 && dc != 0
                // no squeezing between two walls / cutting a wall's corner
                if diagonal && (!isOpen(GridCell(row: current.row + dr, col: current.col)) ||
                                !isOpen(GridCell(row: current.row, col: current.col + dc))) {
                    continue
                }

                // diagonal steps are longer (√2), so straight lines win when it's a tie
                let newCost = cost[current]! + (diagonal ? 1.414 : 1)
                if newCost < cost[next, default: .infinity] {
                    cost[next] = newCost
                    cameFrom[next] = current
                    open.insert(next)
                }
            }
        }
        return nil // no way through
    }

    // MARK: - Arriving

    // called once when the player stops at the end of a route
    func arrived() {
        if let npcCell = talkTarget {
            talkTarget = nil
            talk(to: npcCell)
        } else if seats.contains(currentCell) {
            isSitting = true
        } else if let target = doors[currentCell] {
            goThroughDoor(to: target)
        }
    }

    func talk(to npcCell: GridCell) {
        guard let npc = npcs[npcCell], !npc.lines.isEmpty else { return }

        let index = npcLineIndex[npcCell, default: 0]
        say(npc.lines[index % npc.lines.count], above: npcCell)
        npcLineIndex[npcCell] = index + 1

        // little hop so you can tell who's talking
        npcNodes[npcCell]?.run(.sequence([
            .moveBy(x: 0, y: tileSize * 0.12, duration: 0.08),
            .moveBy(x: 0, y: -tileSize * 0.12, duration: 0.12),
        ]))
    }

    func say(_ text: String, above cell: GridCell) {
        speechBubble?.removeFromParent()

        let label = SKLabelNode(text: text)
        label.fontName = "Thonburi"
        label.fontSize = tileSize * 0.24
        label.fontColor = .black
        label.numberOfLines = 0
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center

        let pad: CGFloat = 12
        let w = label.frame.width + pad * 2
        let h = label.frame.height + pad * 1.5
        let bubble = SKShapeNode(rectOf: CGSize(width: w, height: h), cornerRadius: 10)
        bubble.fillColor = .white
        bubble.strokeColor = UIColor.black.withAlphaComponent(0.2)
        bubble.lineWidth = 1.5
        bubble.addChild(label)

        // above the NPC (and its name), kept inside the board horizontally
        let half = tileSize * CGFloat(gridSize) / 2
        var pos = positionFor(cell)
        let top = npcNodes[cell]?.calculateAccumulatedFrame().maxY ?? pos.y + tileSize * 0.5
        pos.y = top + h / 2 + 4
        pos.x = min(max(pos.x, -half + w / 2), half - w / 2)
        bubble.position = pos
        bubble.zPosition = 50
        bubble.setScale(0.7)
        addChild(bubble)
        speechBubble = bubble

        let pop = SKAction.scale(to: 1, duration: 0.15)
        pop.timingMode = .easeOut
        bubble.run(.sequence([
            pop,
            .wait(forDuration: 3),
            .fadeOut(withDuration: 0.3),
            .removeFromParent(),
        ]))
    }

    func goThroughDoor(to target: String) {
        guard levels[target] != nil else {
            print("⚠️ this door doesn't lead anywhere — check doors in Levels.swift")
            return
        }
        isChangingLevel = true

        let fade = SKSpriteNode(color: .black, size: CGSize(width: size.width * 2, height: size.height * 2))
        fade.zPosition = 100
        fade.alpha = 0
        addChild(fade)

        let from = levelName
        fade.run(.sequence([
            .fadeIn(withDuration: 0.3),
            .run { [weak self] in self?.loadLevel(target, arrivingFrom: from) },
            .fadeOut(withDuration: 0.3),
            .run { [weak self] in self?.isChangingLevel = false },
            .removeFromParent(),
        ]))
    }

    // MARK: - Movement

    // SpriteKit calls this every frame
    override func update(_ currentTime: TimeInterval) {
        // seconds since last frame (capped so a hiccup doesn't make it jump)
        let dt = lastUpdateTime == 0 ? 0 : CGFloat(min(currentTime - lastUpdateTime, 1.0 / 30))
        lastUpdateTime = currentTime

        let maxSpeed = maxSpeedTiles * tileSize
        let accel = accelTiles * tileSize
        let brake = brakeTiles * tileSize

        if route.isEmpty {
            moveSpeed = 0
        } else {
            // fastest we can go right now and still slow down in time for
            // the next corner / the destination
            let limit = max(min(maxSpeed, speedLimitAhead(brake: brake, maxSpeed: maxSpeed)),
                            tileSize * 0.3) // tiny floor so it doesn't crawl the last pixel

            if moveSpeed < limit {
                moveSpeed = min(moveSpeed + accel * dt, limit) // speed up gradually = weight
            } else {
                moveSpeed = limit                              // brake along the limit curve
            }
            advance(by: moveSpeed * dt)
        }

        animateBody(dt: dt, maxSpeed: maxSpeed)
    }

    // looks ahead along the route. at each tile we pass there's a speed we're
    // allowed to be going: 0 at the destination, slower for sharper turns.
    // physics: to reach speed v after distance d while braking at rate a,
    // you can currently be going at most sqrt(v² + 2·a·d).
    func speedLimitAhead(brake: CGFloat, maxSpeed: CGFloat) -> CGFloat {
        var limit = maxSpeed
        var distance: CGFloat = 0
        var from = player.position
        var dirIn = heading

        for (i, cell) in route.enumerated() {
            let to = positionFor(cell)
            let len = hypot(to.x - from.x, to.y - from.y)
            if len > 0 { dirIn = CGVector(dx: (to.x - from.x) / len, dy: (to.y - from.y) / len) }
            distance += len

            let speedHere: CGFloat
            if i == route.count - 1 {
                speedHere = 0 // stop at the destination
            } else {
                let after = positionFor(route[i + 1])
                let outLen = hypot(after.x - to.x, after.y - to.y)
                let dirOut = CGVector(dx: (after.x - to.x) / outLen, dy: (after.y - to.y) / outLen)
                // straight = full speed, 45° ≈ 85%, 90° = 50%, U-turn = stop
                let dot = dirIn.dx * dirOut.dx + dirIn.dy * dirOut.dy
                speedHere = maxSpeed * max(0, (1 + dot) / 2)
            }

            limit = min(limit, sqrt(speedHere * speedHere + 2 * brake * distance))
            from = to
        }
        return limit
    }

    // moves the player along the route; can pass through several tiles in one frame
    func advance(by distance: CGFloat) {
        var remaining = distance
        while remaining > 0, let next = route.first {
            let target = positionFor(next)
            let dx = target.x - player.position.x
            let dy = target.y - player.position.y
            let d = hypot(dx, dy)

            if d <= remaining {
                // reached this tile, carry the leftover distance into the next one
                player.position = target
                currentCell = next
                route.removeFirst()
                remaining -= d
                if route.isEmpty {
                    arrived()
                    break
                }
            } else {
                heading = CGVector(dx: dx / d, dy: dy / d)
                player.position.x += heading.dx * remaining
                player.position.y += heading.dy * remaining
                remaining = 0
            }
        }
        // 2 little bobs per tile walked
        walkPhase += distance / tileSize * .pi * 2
    }

    // little touches that sell the weight: a bob per step and a lean into the walk
    func animateBody(dt: CGFloat, maxSpeed: CGFloat) {
        let effort = maxSpeed > 0 ? moveSpeed / maxSpeed : 0 // 0 standing … 1 full speed

        // ease into / out of sitting
        sitAmount += ((isSitting ? 1 : 0) - sitAmount) * min(1, dt * 8)

        let bob = abs(sin(walkPhase)) * 0.08 * effort
        player.yScale = (1 + bob) * (1 - 0.25 * sitAmount)   // squash down when sitting
        player.xScale = (1 - bob * 0.5) * (1 + 0.1 * sitAmount)

        // lean in the direction of travel, eased so it doesn't snap
        let targetTilt = -heading.dx * 0.12 * effort
        tilt += (targetTilt - tilt) * min(1, dt * 10)
        player.zRotation = tilt
    }

    // ring that pops on the tapped tile so you know the tap registered
    func showTapMarker(at cell: GridCell, color: UIColor) {
        let marker = SKShapeNode(circleOfRadius: tileSize * 0.35)
        marker.strokeColor = color
        marker.lineWidth = 3
        marker.fillColor = .clear
        marker.position = positionFor(cell)
        marker.zPosition = 5
        marker.setScale(0.6)
        addChild(marker)

        let grow = SKAction.scale(to: 1, duration: 0.25)
        grow.timingMode = .easeOut
        marker.run(.sequence([
            .group([grow, .fadeOut(withDuration: 0.4)]),
            .removeFromParent()
        ]))
    }
}
