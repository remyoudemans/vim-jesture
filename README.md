# vim-jesture
An elegant set of jest helpers for testing javascript with ease

*IMPORTANT*: _All_ mappings start with `<leader>j`. All of the following mapping
descriptions omit it. Read every mapping as: `<leader>j{mapping}`.

Mappings:
- Alternation mappings:
  - Alternate test:
    - `at`: alternate between `filename.*` and `filename.test.*` or (if you already have a `__tests__` folder) `__tests__/filename.test.*`.
    - `vt`: like `at` but opens in a vertical split.
    - `ht`: like `at` but opens in a horizontal split.
  - Alternate mock:
    - `am`: alternate between `filename.*` and `__mocks__/filename.*` (and optionally create `__mocks__` directory if it doesn't exist).
    - `vm`: like `am` but opens in a vertical split.
    - `hm`: like `am` but opens in a horizontal split.
- Only mappings:
  - `to`: toggle current assertion between `it` and `it.only`.
  - `oo`: like `to` but also removes all other `only`s in buffer if it is toggling `only` on (making the assertion the Only Only).
  - `ro`: makes all `it.only` assertions simple `it` assertions (Removing Onlies).
- Mocking import mappings:
  - `mi`: mock import of current line in the next line.
