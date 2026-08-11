-- Which byte sequence draws which glyph code.
return {
  ["~"] = 0x100,
  ["ª"] = 0x101,
  ["º"] = 0x102,
  ["Á"] = 0x103,
  ["É"] = 0x104,
  ["Í"] = 0x105,
  ["Ñ"] = 0x106,
  ["Ó"] = 0x107,
  ["Ú"] = 0x108,
  ["Ü"] = 0x109,
  ["à"] = 0x10A, -- Pesca la 'á'
  ["ì"] = 0x10B, -- Pesca la 'í'
  ["è"] = 0x104, -- Pesca temporaneamente la 'É' maiuscola per evitare l'ondina della ñ
  ["ò"] = 0x10D, -- Pesca la 'ó'
  ["ù"] = 0x10E, -- Pesca la 'ú'
  ["ü"] = 0x10F,
  ["¿"] = 0x110,
  ["¡"] = 0x111,
}