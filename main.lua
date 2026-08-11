-- Gen1Recomp-Italian-Translation: a translation of the game into Italian.
--
-- Read TRANSLATING.md before the first edit; the font is the part people
-- get wrong.
return function(mod)
  -- mod:read is the supported way into your own directory; the catalogs are
  -- plain Lua tables, so read and run them rather than require()ing them.
  local function catalog(name)
    local rel = "lang/" .. name .. ".lua"
    local body = mod:read(rel)
    if not body then return {} end
    local chunk, err = loadstring(body, rel)
    if not chunk then
      mod.log:warn("%s has a syntax error: %s", rel, tostring(err))
      return {}
    end
    local ok, table_ = pcall(chunk)
    if not ok or type(table_) ~= "table" then
      mod.log:warn("%s did not return a table: %s", rel, tostring(table_))
      return {}
    end
    return table_
  end

  -- An empty value means "not translated yet", never "translate to blank".
  local function each(name, apply)
    local n = 0
    for key, value in pairs(catalog(name)) do
      if type(value) == "string" and value ~= "" then
        apply(key, value)
        n = n + 1
      end
    end
    return n
  end

  -- ---- glyphs -------------------------------------------------------
  -- Register the sheet BEFORE anything asks for a glyph on it.  base is
  -- the first code the page owns; 0x100 and up is free space above the
  -- vanilla pages, so a new alphabet never collides with them.
  for id, page in pairs(catalog("font")) do
    -- A page's `image` goes straight to love.graphics.newImage, which
    -- resolves against the game root rather than the mod, so a path that
    -- lives in this mod has to be made absolute or the page loads nothing
    -- and every accented character draws as a blank.  mod:read is the
    -- precise test for "this file is mine".
    if type(page) == "table" and type(page.image) == "string"
        and mod:read(page.image) then
      page.image = mod.assets:path(page.image)
    end
    mod.content.font:register(id, page)
  end
  -- charmap: which byte sequence draws which code
  for seq, code in pairs(catalog("charmap")) do
    mod.content.font:register("charmap:" .. seq, { seq = seq, code = code })
  end

  -- ---- text ---------------------------------------------------------
  local counts = {}
  counts.dialogue = each("dialogue", function(id, value)
    mod.content.text:override(id, value)
  end)
  counts.strings = each("strings", function(source, value)
    mod.content.strings:override(source, value)
  end)
  counts.species = each("species_names", function(id, value)
    mod.content.pokemon:patch(id, { name = value })
  end)
  counts.moves = each("move_names", function(id, value)
    mod.content.moves:patch(id, { name = value })
  end)
  counts.items = each("item_names", function(id, value)
    mod.content.items:patch(id, { name = value })
  end)
  counts.trainers = each("trainer_names", function(id, value)
    mod.content.trainers:patch(id, { name = value })
  end)
  counts.statuses = each("status_labels", function(id, value)
    mod.content.statuses:patch(id, { label = value })
  end)

  -- ---- name entry ---------------------------------------------------
  local grid = catalog("naming")
  if grid.upper or grid.lower then
    mod.hooks:wrap("ui.naming.grid", function(base, ctx)
      local want = ctx and ctx.lower and grid.lower or grid.upper
      return want or base
    end)
  end

  mod.events:on("game.ready", function()
    local total = 0
    for _, n in pairs(counts) do total = total + n end
    mod.log:info("Italiano: %d stringhe tradotte", total)
  end)

  -- Pokedex species kinds (Categorie Pokédex in italiano)
  mod.content.pokemon:patch("BULBASAUR", {dexEntry = { kind = "SEME" }})
  mod.content.pokemon:patch("IVYSAUR", {dexEntry = { kind = "SEME" }})
  mod.content.pokemon:patch("VENUSAUR", {dexEntry = { kind = "SEME" }})
  mod.content.pokemon:patch("CHARMANDER", {dexEntry = { kind = "LUCERTOLA" }})
  mod.content.pokemon:patch("CHARMELEON", {dexEntry = { kind = "FIAMMA" }})
  mod.content.pokemon:patch("CHARIZARD", {dexEntry = { kind = "FIAMMA" }})
  mod.content.pokemon:patch("SQUIRTLE", {dexEntry = { kind = "TARTARUGHINA" }})
  mod.content.pokemon:patch("WARTORTLE", {dexEntry = { kind = "TARTARUGA" }})
  mod.content.pokemon:patch("BLASTOISE", {dexEntry = { kind = "CROSTACEO" }})
  mod.content.pokemon:patch("CATERPIE", {dexEntry = { kind = "VERME" }})
  mod.content.pokemon:patch("METAPOD", {dexEntry = { kind = "BOZZOLO" }})
  mod.content.pokemon:patch("BUTTERFREE", {dexEntry = { kind = "FARFALLA" }})
  mod.content.pokemon:patch("WEEDLE", {dexEntry = { kind = "INSETTO" }})
  mod.content.pokemon:patch("KAKUNA", {dexEntry = { kind = "BOZZOLO" }})
  mod.content.pokemon:patch("BEEDRILL", {dexEntry = { kind = "VELENOAPE" }})
  mod.content.pokemon:patch("PIDGEY", {dexEntry = { kind = "UCCELLETTO" }})
  mod.content.pokemon:patch("PIDGEOTTO", {dexEntry = { kind = "UCCELLO" }})
  mod.content.pokemon:patch("PIDGEOT", {dexEntry = { kind = "UCCELLO" }})
  mod.content.pokemon:patch("RATTATA", {dexEntry = { kind = "TOPO" }})
  mod.content.pokemon:patch("RATICATE", {dexEntry = { kind = "TOPO" }})
  mod.content.pokemon:patch("SPEAROW", {dexEntry = { kind = "UCCELLETTO" }})
  mod.content.pokemon:patch("FEAROW", {dexEntry = { kind = "BECCO" }})
  mod.content.pokemon:patch("EKANS", {dexEntry = { kind = "SERPENTE" }})
  mod.content.pokemon:patch("ARBOK", {dexEntry = { kind = "COBRA" }})
  mod.content.pokemon:patch("PIKACHU", {dexEntry = { kind = "TOPO" }})
  mod.content.pokemon:patch("RAICHU", {dexEntry = { kind = "TOPO" }})
  mod.content.pokemon:patch("SANDSHREW", {dexEntry = { kind = "TOPO" }})
  mod.content.pokemon:patch("SANDSLASH", {dexEntry = { kind = "TOPO" }})
  mod.content.pokemon:patch("NIDORAN_F", {dexEntry = { kind = "VELENOPIN" }})
  mod.content.pokemon:patch("NIDORINA", {dexEntry = { kind = "VELENOPIN" }})
  mod.content.pokemon:patch("NIDOQUEEN", {dexEntry = { kind = "TRAPANO" }})
  mod.content.pokemon:patch("NIDORAN_M", {dexEntry = { kind = "VELENOPIN" }})
  mod.content.pokemon:patch("NIDORINO", {dexEntry = { kind = "VELENOPIN" }})
  mod.content.pokemon:patch("NIDOKING", {dexEntry = { kind = "TRAPANO" }})
  mod.content.pokemon:patch("CLEFAIRY", {dexEntry = { kind = "FATA" }})
  mod.content.pokemon:patch("CLEFABLE", {dexEntry = { kind = "FATA" }})
  mod.content.pokemon:patch("VULPIX", {dexEntry = { kind = "VOLPE" }})
  mod.content.pokemon:patch("NINETALES", {dexEntry = { kind = "VOLPE" }})
  mod.content.pokemon:patch("JIGGLYPUFF", {dexEntry = { kind = "PALLONE" }})
  mod.content.pokemon:patch("WIGGLYTUFF", {dexEntry = { kind = "PALLONE" }})
  mod.content.pokemon:patch("ZUBAT", {dexEntry = { kind = "PIPISTRELLO" }})
  mod.content.pokemon:patch("GOLBAT", {dexEntry = { kind = "PIPISTRELLO" }})
  mod.content.pokemon:patch("ODDISH", {dexEntry = { kind = "ERBACCIA" }})
  mod.content.pokemon:patch("GLOOM", {dexEntry = { kind = "ERBACCIA" }})
  mod.content.pokemon:patch("VILEPLUME", {dexEntry = { kind = "FIORE" }})
  mod.content.pokemon:patch("PARAS", {dexEntry = { kind = "FUNGO" }})
  mod.content.pokemon:patch("PARASECT", {dexEntry = { kind = "FUNGO" }})
  mod.content.pokemon:patch("VENONAT", {dexEntry = { kind = "INSETTO" }})
  mod.content.pokemon:patch("VENOMOTH", {dexEntry = { kind = "LUCCHIOLE" }})
  mod.content.pokemon:patch("DIGLETT", {dexEntry = { kind = "TALPA" }})
  mod.content.pokemon:patch("DUGTRIO", {dexEntry = { kind = "TALPA" }})
  mod.content.pokemon:patch("MEOWTH", {dexEntry = { kind = "GATTO" }})
  mod.content.pokemon:patch("PERSIAN", {dexEntry = { kind = "GATTO" }})
  mod.content.pokemon:patch("PSYDUCK", {dexEntry = { kind = "ANATRA" }})
  mod.content.pokemon:patch("GOLDUCK", {dexEntry = { kind = "ANATRA" }})
  mod.content.pokemon:patch("MANKEY", {dexEntry = { kind = "PIGMEO" }})
  mod.content.pokemon:patch("PRIMEAPE", {dexEntry = { kind = "PIGMEO" }})
  mod.content.pokemon:patch("GROWLITHE", {dexEntry = { kind = "CUCCIOLO" }})
  mod.content.pokemon:patch("ARCANINE", {dexEntry = { kind = "LEGGENDARIO" }})
  mod.content.pokemon:patch("POLIWAG", {dexEntry = { kind = "GIRINO" }})
  mod.content.pokemon:patch("POLIWHIRL", {dexEntry = { kind = "GIRINO" }})
  mod.content.pokemon:patch("POLIWRATH", {dexEntry = { kind = "GIRINO" }})
  mod.content.pokemon:patch("ABRA", {dexEntry = { kind = "PSI" }})
  mod.content.pokemon:patch("KADABRA", {dexEntry = { kind = "PSI" }})
  mod.content.pokemon:patch("ALAKAZAM", {dexEntry = { kind = "PSI" }})
  mod.content.pokemon:patch("MACHOP", {dexEntry = { kind = "SUPERPOTERE" }})
  mod.content.pokemon:patch("MACHOKE", {dexEntry = { kind = "SUPERPOTERE" }})
  mod.content.pokemon:patch("MACHAMP", {dexEntry = { kind = "SUPERPOTERE" }})
  mod.content.pokemon:patch("BELLSPROUT", {dexEntry = { kind = "FIORE" }})
  mod.content.pokemon:patch("WEEPINBELL", {dexEntry = { kind = "ACCHIAPPAMOSCHE" }})
  mod.content.pokemon:patch("VICTREEBEL", {dexEntry = { kind = "ACCHIAPPAMOSCHE" }})
  mod.content.pokemon:patch("TENTACOOL", {dexEntry = { kind = "MEDUSA" }})
  mod.content.pokemon:patch("TENTACRUEL", {dexEntry = { kind = "MEDUSA" }})
  mod.content.pokemon:patch("GEODUDE", {dexEntry = { kind = "ROCCIA" }})
  mod.content.pokemon:patch("GRAVELER", {dexEntry = { kind = "ROCCIA" }})
  mod.content.pokemon:patch("GOLEM", {dexEntry = { kind = "MEGATONE" }})
  mod.content.pokemon:patch("PONYTA", {dexEntry = { kind = "CAVALLOFUOCO" }})
  mod.content.pokemon:patch("RAPIDASH", {dexEntry = { kind = "CAVALLOFUOCO" }})
  mod.content.pokemon:patch("SLOWPOKE", {dexEntry = { kind = "RONZINO" }})
  mod.content.pokemon:patch("SLOWBRO", {dexEntry = { kind = "EREMITA" }})
  mod.content.pokemon:patch("MAGNEMITE", {dexEntry = { kind = "CALAMITA" }})
  mod.content.pokemon:patch("MAGNETON", {dexEntry = { kind = "CALAMITA" }})
  mod.content.pokemon:patch("FARFETCHD", {dexEntry = { kind = "ANATRA" }})
  mod.content.pokemon:patch("DODUO", {dexEntry = { kind = "UCCELLOBIGEMELLO" }})
  mod.content.pokemon:patch("DODRIO", {dexEntry = { kind = "TRIPLOUCCELLO" }})
  mod.content.pokemon:patch("SEEL", {dexEntry = { kind = "LEONE MARINO" }})
  mod.content.pokemon:patch("DEWGONG", {dexEntry = { kind = "LEONE MARINO" }})
  mod.content.pokemon:patch("GRIMER", {dexEntry = { kind = "MELMA" }})
  mod.content.pokemon:patch("MUK", {dexEntry = { kind = "MELMA" }})
  mod.content.pokemon:patch("SHELLDER", {dexEntry = { kind = "BIVALVE" }})
  mod.content.pokemon:patch("CLOYSTER", {dexEntry = { kind = "BIVALVE" }})
  mod.content.pokemon:patch("GASTLY", {dexEntry = { kind = "GAS" }})
  mod.content.pokemon:patch("HAUNTER", {dexEntry = { kind = "GAS" }})
  mod.content.pokemon:patch("GENGAR", {dexEntry = { kind = "OMBRA" }})
  mod.content.pokemon:patch("ONIX", {dexEntry = { kind = "SERPENTEROCCIA" }})
  mod.content.pokemon:patch("DROWZEE", {dexEntry = { kind = "IPNOSI" }})
  mod.content.pokemon:patch("HYPNO", {dexEntry = { kind = "IPNOSI" }})
  mod.content.pokemon:patch("KRABBY", {dexEntry = { kind = "GRANCHIO" }})
  mod.content.pokemon:patch("KINGLER", {dexEntry = { kind = "FORBICE" }})
  mod.content.pokemon:patch("VOLTORB", {dexEntry = { kind = "PALLA" }})
  mod.content.pokemon:patch("ELECTRODE", {dexEntry = { kind = "PALLA" }})
  mod.content.pokemon:patch("EXEGGCUTE", {dexEntry = { kind = "UOVO" }})
  mod.content.pokemon:patch("EXEGGUTOR", {dexEntry = { kind = "COCCO" }})
  mod.content.pokemon:patch("CUBONE", {dexEntry = { kind = "SOLITARIO" }})
  mod.content.pokemon:patch("MAROWAK", {dexEntry = { kind = "OSSOPALETTA" }})
  mod.content.pokemon:patch("HITMONLEE", {dexEntry = { kind = "TIRACALCI" }})
  mod.content.pokemon:patch("HITMONCHAN", {dexEntry = { kind = "TIRAPUGNI" }})
  mod.content.pokemon:patch("LICKITUNG", {dexEntry = { kind = "LINGUACCIA" }})
  mod.content.pokemon:patch("KOFFING", {dexEntry = { kind = "VELENOGAS" }})
  mod.content.pokemon:patch("WEEZING", {dexEntry = { kind = "VELENOGAS" }})
  mod.content.pokemon:patch("RHYHORN", {dexEntry = { kind = "SPINO" }})
  mod.content.pokemon:patch("RHYDON", {dexEntry = { kind = "TRAPANO" }})
  mod.content.pokemon:patch("CHANSEY", {dexEntry = { kind = "UOVO" }})
  mod.content.pokemon:patch("TANGELA", {dexEntry = { kind = "LICHENE" }})
  mod.content.pokemon:patch("KANGASKHAN", {dexEntry = { kind = "GENITORE" }})
  mod.content.pokemon:patch("HORSEA", {dexEntry = { kind = "DRAGO" }})
  mod.content.pokemon:patch("SEADRA", {dexEntry = { kind = "DRAGO" }})
  mod.content.pokemon:patch("GOLDEEN", {dexEntry = { kind = "PESCICOLOR" }})
  mod.content.pokemon:patch("SEAKING", {dexEntry = { kind = "PESCICOLOR" }})
  mod.content.pokemon:patch("STARYU", {dexEntry = { kind = "STELLA" }})
  mod.content.pokemon:patch("STARMIE", {dexEntry = { kind = "MISTERO" }})
  mod.content.pokemon:patch("MR_MIME", {dexEntry = { kind = "BARRIERA" }})
  mod.content.pokemon:patch("SCYTHER", {dexEntry = { kind = "MANTIDE" }})
  mod.content.pokemon:patch("JYNX", {dexEntry = { kind = "UMANOIDE" }})
  mod.content.pokemon:patch("ELECTABUZZ", {dexEntry = { kind = "ELETTRICO" }})
  mod.content.pokemon:patch("MAGMAR", {dexEntry = { kind = "SPITFIRE" }})
  mod.content.pokemon:patch("PINSIR", {dexEntry = { kind = "CERVOVOLANTE" }})
  mod.content.pokemon:patch("TAUROS", {dexEntry = { kind = "BUFFALO" }})
  mod.content.pokemon:patch("MAGIKARP", {dexEntry = { kind = "PESCE" }})
  mod.content.pokemon:patch("GYARADOS", {dexEntry = { kind = "ATROCE" }})
  mod.content.pokemon:patch("LAPRAS", {dexEntry = { kind = "TRASPORTO" }})
  mod.content.pokemon:patch("DITTO", {dexEntry = { kind = "MUTANTE" }})
  mod.content.pokemon:patch("EEVEE", {dexEntry = { kind = "EVOLUZIONE" }})
  mod.content.pokemon:patch("VAPOREON", {dexEntry = { kind = "BOLLA" }})
  mod.content.pokemon:patch("JOLTEON", {dexEntry = { kind = "FULMINE" }})
  mod.content.pokemon:patch("FLAREON", {dexEntry = { kind = "FIAMMA" }})
  mod.content.pokemon:patch("PORYGON", {dexEntry = { kind = "VIRTUALE" }})
  mod.content.pokemon:patch("OMANYTE", {dexEntry = { kind = "SPIRALE" }})
  mod.content.pokemon:patch("OMASTAR", {dexEntry = { kind = "SPIRALE" }})
  mod.content.pokemon:patch("KABUTO", {dexEntry = { kind = "CROSTACEO" }})
  mod.content.pokemon:patch("KABUTOPS", {dexEntry = { kind = "CROSTACEO" }})
  mod.content.pokemon:patch("AERODACTYL", {dexEntry = { kind = "FOSSILE" }})
  mod.content.pokemon:patch("SNORLAX", {dexEntry = { kind = "SONNO" }})
  mod.content.pokemon:patch("ARTICUNO", {dexEntry = { kind = "GELO" }})
  mod.content.pokemon:patch("ZAPDOS", {dexEntry = { kind = "ELETTRICO" }})
  mod.content.pokemon:patch("MOLTRES", {dexEntry = { kind = "FIAMMA" }})
  mod.content.pokemon:patch("DRATINI", {dexEntry = { kind = "DRAGO" }})
  mod.content.pokemon:patch("DRAGONAIR", {dexEntry = { kind = "DRAGO" }})
  mod.content.pokemon:patch("DRAGONITE", {dexEntry = { kind = "DRAGO" }})
  mod.content.pokemon:patch("MEWTWO", {dexEntry = { kind = "GENETICO" }})
  mod.content.pokemon:patch("MEW", {dexEntry = { kind = "NUOVA SPECIE" }})

end