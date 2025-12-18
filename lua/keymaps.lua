-- Clear search highlighting with <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Toggle file manager
vim.keymap.set("n", "<c-n>", ":NvimTreeToggle<cr>", { noremap = true })
-- Fuzzy find for files
vim.keymap.set("n", "<leader>sf", ":Pick files<cr>", { noremap = true })
-- Fuzzy find for content
vim.keymap.set("n", "<leader>sg", ":Pick grep_live<cr>", { noremap = true })
-- Fuzzy find NeoVim config files (defined in picker.lua)
-- vim.keymap.set("n", "<leader>sn", pick_neovim_config, { noremap = true })
-- Go to buffer number with <Space> b <buffer_number><Enter>
vim.keymap.set("n", "<leader>b", ":BufferLineGoToBuffer ", { desc = "Open [B]uffer (tab) number", noremap = true })
-- Go to next buffer with <Space> <Tab>
vim.keymap.set("n", "<leader><Tab>", ":BufferLineCycleNext<CR>", { desc = "Cycle next tab", noremap = true })
-- Go to previous buffer with <Space> <Shift-Tab>
vim.keymap.set("n", "<leader><Shift-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Cycle previous tab", noremap = true })
-- Close current buffer with :bd
-- Zen mode
vim.keymap.set("n", "<leader>z", ":ZenMode<cr>", { noremap = true })
