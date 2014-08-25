Vec2 := Sequence clone setItemType("float32") setSize(2) do(
	point := method(asStruct(list("float32", "x", "float32", "y")))
	fromPoint := method(p, clone withStruct(list("float32", p x, "float32", p y)))
	)

Point := Object clone do(
	x ::= 0
	y ::= 0
	asString := method("Point(#{x}, #{y})" interpolate)
	with := method(x, y, self clone setX(x) setY(y))
	fromVector := method(vec, self with(vec at(0), vec at(1)))
	vector := method(Vec2 clone atPut(0, x) atPut(1, y))
  fromMap := method(map,
    if(map == nil, 
      self with(0, 0), 
      self with(map at("x"), map at("y"))))
)

Vindi := Object clone 

Vindi Hero := Object clone do(
  id := nil
  name := nil
  userId := nil
  elo := nil
  pos := nil
  life := nil
  gold := nil
  mineCount := nil
  spawnPos := nil
  crashed := nil
  
  fromMap := method(map,
    hero := self clone
    hero id =  map at("id")
    hero name = map at("name")
    hero userId = map at("userId")
    hero elo = map at("elo")
    hero pos = Point fromMap(map at("pos"))
    hero life = map at("life")
    hero gold = map at("gold")
    hero mineCount = map at("mineCount")
    hero spawnPos = Point fromMap(map at("spanwPos"))
    hero crashed = map at("crashed")
    hero)
)

Vindi Tile := Object clone do(
  pos ::= Point with(0, 0) vector
  name ::= nil
  code ::= nil

  x := method(pos at(0))
  y := method(pos at(0))

  asString := method(code)

  isFloor := method(code == "  ")
  isWood := method(code == "##")
  isGoldMine := method(code findSeq("$"))
  isTavern := method(code == "[]")

  with := method(x, y, code,
    tile := self clone setCode(code)
    if(tile isFloor) then(
      name := "floor"
    ) elseif(tile isWood) then(
      name := "wood"
    ) elseif(tile isGoldMine) then(
      name := "gold mine"
    ) elseif(tile isTavern) then(
      name := "tavern"
    ) else(
      name := "unknown"
    )

    self clone setPos(Point with(x, y) vector) setName(name) setCode(code))
)

Vindi Board := Object clone do(
  debug := false
  size := nil
  tiles := nil
  finished := nil

  at := method(x, y, tiles at(size * y + x))

  fromMap := method(map,
    board := self clone
    board size = map at("size") asNumber
    board finished = map at("finished")
    board tiles = List clone

    size := board size 

    for(i, 0, (size * size) + 2,
      y := (i / size) floor
      x := i - (size * y)

      code := map at("tiles") exclusiveSlice(i * 2, i * 2 + 2)

      if(debug != false,
        "tile(x: #{x}, y: #{y} code: #{code})" interpolate println)

      board tiles append(Vindi Tile with(x, y, code)))
    board)

  asString := method(
    buf := List clone
    lastY := 0
    tiles foreach(tile,
      buf append(tile asString)

      if(tile x + 1 == size, buf append("\n")))
    buf join(""))
)

Vindi Game := Object clone do(
  id := nil
  key ::= nil
  turns ::= 300
  mapId ::= nil

  turn := nil
  maxTurns := nil
  heroes := List clone
  board := nil

  finished := nil
  hero := nil
  token := nil
  viewUrl := nil
  playUrl := nil

  move := method(dir,
    clone fetch(playUrl, Map with("key", key asString, "dir", dir asString)))

  with := method(key,
    params := Map with("key", key asString, "turns", turns asString)
    if(mapId != nil, params atPut("map", mapId asString))
    clone fetch(Vindi api, params))

  fetch := method(url, params,
    err := try(
      result := Yajl parseJson(URL with(url) post(params, Map clone)))
    if(err != nil, nil, 
      if(result hasSlot("at"),
        readGame(key, turns, mapId, result),
        result println
        nil)))

  readGame := method(key, turns, mapId, params,
    game := clone setKey(key) setTurns(turns) setMapId(mapId) 
    game id = params at("game") at("id")
    game turn = params at("game") at("turn")
    game maxTurns = params at("game") at("maxTurns")
    game heroes = params at("game") at("heroes") map(h, Vindi Hero fromMap(h))
    game turn = params at("game") at("turn")
    game board = Vindi Board fromMap(params at("game") at("board"))
    game finished = params at("game") at("finished")
    game hero = Vindi Hero fromMap(params at("hero"))
    game token = params at("token")
    game viewUrl = params at("viewUrl")
    game playUrl = params at("playUrl")
    game)
)


Vindi do(
  training := "http://vindinium.org/api/training"
	arena := "http://vindinium.org/api/arena"
	
  api := training

  newGame := method(key, Vindi Game with(key))
)

