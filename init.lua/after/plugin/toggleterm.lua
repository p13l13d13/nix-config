require("toggleterm").setup{
  size =  35,
  open_mapping = [[<leader>\]],
  autochdir = true,
  shade_terminals = true,
  start_in_insert = true,
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}
