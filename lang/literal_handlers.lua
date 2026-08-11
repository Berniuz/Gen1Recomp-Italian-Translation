-- Generated qid-driven literal dialogue handlers.
return function(mod)
  local TextBox = mod.ui.TextBox
  local ChoiceBox = mod.ui.ChoiceBox
  mod.content.map_scripts:register("VIRIDIAN_CITY", {talk = {
    ["TEXT_VIRIDIANCITY_YOUNGSTER2"] = function(game, ow, npc, done)
      game.stack:push(TextBox.new(game, "¿Vuoi saperne\nqualcosa sui 2\11tipi di bruco\11POKéMON?", function()
        game.stack:push(ChoiceBox.new(game, function(yes)
          game.stack:push(TextBox.new(game, yes and "CATERPIE non ha\nveleno, ma WEEDLE\11sì!\12Attento al suo\nVELENAGUIDONE!" or "Oh, va bene!", done))
        end))
      end))
    end,
  },
  })
  mod.content.map_scripts:register("MUSEUM_1F", {talk = {
    ["TEXT_MUSEUM1F_SCIENTIST1"] = function(game, ow, npc, done)
      if game.save.flags["EVENT_BOUGHT_MUSEUM_TICKET"] then
        game.stack:push(TextBox.new(game, "C'è molto\nda vedere!", done))
      else
        game.stack:push(TextBox.new(game, "Sono ¥50 per un\nbiglietto ridotto.\12Vuoi entrare?", function()
          game.stack:push(ChoiceBox.new(game, function(yes)
            if yes then
              if (game.save.money or 0) >= 50 then
                game.save.money = (game.save.money or 0) + (-50)
                game.save.flags["EVENT_BOUGHT_MUSEUM_TICKET"] = true
                game.stack:push(TextBox.new(game, "¥50! D'accordo!\nGrazie!", done))
              else
                game.stack:push(TextBox.new(game, "Non hai abbastanza\nsoldi.", done))
              end
            else
              game.stack:push(TextBox.new(game, "A presto!", done))
            end
          end))
        end))
      end
    end,
  },
    onStep = function(game, ow, x, y)
      if ((x == 9 and y == 4) or (x == 10 and y == 4)) and not game.save.flags["EVENT_BOUGHT_MUSEUM_TICKET"] then
        local function on_done() end
        game.stack:push(TextBox.new(game, "Sono ¥50 per un\nbiglietto ridotto.\12Vuoi entrare?", function()
          game.stack:push(ChoiceBox.new(game, function(yes)
            if yes then
              if (game.save.money or 0) >= 50 then
                game.save.money = (game.save.money or 0) + (-50)
                game.save.flags["EVENT_BOUGHT_MUSEUM_TICKET"] = true
                game.stack:push(TextBox.new(game, "¥50! D'accordo!\nGrazie!", on_done))
              else
                game.stack:push(TextBox.new(game, "Non hai abbastanza\nsoldi.", function()
                  ow:scriptMove(ow.player, "down", 1, on_done)
                end))
              end
            else
              game.stack:push(TextBox.new(game, "A presto!", function()
                ow:scriptMove(ow.player, "down", 1, on_done)
              end))
            end
          end))
        end))
        return true
      end
      return false
    end,
  })
  mod.content.map_scripts:register("BIKE_SHOP", {talk = {
    ["TEXT_BIKESHOP_CLERK"] = function(game, ow, npc, done)
      if (game.save.inventory["BICYCLE"] or 0) > 0 then
        game.stack:push(TextBox.new(game, "Ti piace la tua\nnuova BICICLETTA?\12Usala sulla PISTA\nCICLABILE e nelle\11grotte!", done))
      else
        if (game.save.inventory["BIKE_VOUCHER"] or 0) > 0 then
          game.stack:push(TextBox.new(game, "Oh! Quello è...\nUn BUONO BICICLETTA!\12Benissimo!\nÈ tua!", function()
            game.save.inventory["BIKE_VOUCHER"] = nil
            game.save.inventory["BICYCLE"] = 1
            game.save.flags["EVENT_GOT_BICYCLE"] = true
            game.stack:push(TextBox.new(game, "{PLAYER} scambia\nil BUONO per una\11BICICLETTA.", done))
          end))
        else
          game.stack:push(TextBox.new(game, "Benvenuto al\nNEGOZIO DI BICI!\12Abbiamo la bici\nche fa per te!", done))
        end
      end
    end,
  },
  })
  mod.content.map_scripts:register("BIKE_SHOP", {talk = {
    ["TEXT_BIKESHOP_MIDDLE_AGED_WOMAN"] = function(game, ow, npc, done)
      game.stack:push(TextBox.new(game, "Mi serve solo una\nBICICLETTA normale!\12Non puoi metterci\nun cestino su una\11MOTOCICLETTA!", done))
    end,
  },
  })
  mod.content.map_scripts:register("BIKE_SHOP", {talk = {
    ["TEXT_BIKESHOP_YOUNGSTER"] = function(game, ow, npc, done)
      if (game.save.flags["EVENT_GOT_BICYCLE"] or (game.save.inventory["BICYCLE"] or 0) > 0) then
        game.stack:push(TextBox.new(game, "Uau! Che bella\nBICI!", done))
      else
        game.stack:push(TextBox.new(game, "Queste BICI sono\nfantastiche, ma\11costano troppo!", done))
      end
    end,
  },
  })
end