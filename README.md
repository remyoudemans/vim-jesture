# vim-jesture
Jest utilities for greater testing productivity

Highlights include:
- `<leader>jro`      remove all `only`s from file.
- `<leader>joo`      toggle current `it` block between `it.only` and just `it`; and removes all other `only`s if it is toggling `only` on.
- `<leader>jto`      toggle current `it` block between `it.only` and just `it`.
- `<leader>jmi`       mock import of current line, beneath it.
- Alternate test:
  - `<leader>jat`      alternate between `filename.*` and `filename.test.*` or (if you already have a `__tests__` folder) `__tests__/filename.test.*`.
  - `<leader>jvt`      like `<leader>jat` but opens the file in a vertical split.
  - `<leader>jht`      like `<leader>jat` but opens the file in a horizontal split.
- Alternate mock:
  - `<leader>jam`      alternate between `filename.*` and `__mocks__/filename.*` (optionally create __mocks__ directory if it doesn't exist). 
  - `<leader>jvm`      like `<leader>jam` but opens the file in a vertical split.
  - `<leader>jhm`      like `<leader>jam` but opens the file in a horizontal split.
