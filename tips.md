# Neovim Pro Tips: Web Development & Text Object Mastery

This guide provides a comprehensive overview of the powerful features configured in your `init.lua` to help you code more efficiently, especially for web development. It also includes a deep dive into the world of text objects.

## Part 1: Professional Web Development Tricks

Your Neovim is set up with a suite of plugins that make HTML and web development a breeze.

### 1. Emmet: Write HTML at the Speed of Thought

Emmet is a toolkit that allows you to write complex HTML structures using CSS-like selectors. Your setup uses `emmet_ls` to provide these capabilities.

**How to use:** Type an abbreviation in an HTML file and press your completion key (e.g., `<C-y>`) to expand it.

**Common Emmet Abbreviations:**

| Abbreviation                          | Expanded HTML                                                                                             |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `!` or `html:5`                       | Generates a full HTML5 boilerplate document.                                                              |
| `div#header`                          | `<div id="header"></div>`                                                                                 |
| `div.container`                       | `<div class="container"></div>`                                                                           |
| `ul>li*5`                             | `<ul><li></li><li></li><li></li><li></li><li></li></ul>`                                                   |
| `h1{Hello World}`                     | `<h1>Hello World</h1>`                                                                                    |
| `a[href=#]`                           | `<a href="#"></a>`                                                                                        |
| `input:text`                          | `<input type="text" name="" id="">`                                                                       |
| `p>lorem20`                           | `<p>Lorem ipsum dolor sit amet...</p>` (20 words of placeholder text)                                      |
| `nav>ul>li.item$*4>a{Item $}`         | Expands to a full navigation menu with numbered items.                                                    |

### 2. `nvim-ts-autotag`: Never Forget a Closing Tag

This plugin automatically manages HTML/XML tags for you.

- **Auto-closing:** Type `<p>` and `</p>` is inserted automatically.
- **Auto-renaming:** Place your cursor on `div` in `<div>`, rename it to `section`, and the closing `</div>` will automatically become `</section>`.

### 3. `mini.surround`: Master Your Surroundings

This plugin makes adding, changing, and deleting surrounding pairs (like `()`, `[]`, `''`, `""`, and HTML tags) incredibly efficient.

**Key Commands (Normal Mode):**

| Command     | Action                                       | Example                                     |
| ----------- | -------------------------------------------- | ------------------------------------------- |
| `ys` + obj  | **Y**ank **S**urround (add surroundings)     | `ysiw<div>` surrounds the current word      |
| `ds`        | **D**elete **S**urroundings                  | `ds"` deletes surrounding double quotes      |
| `cs`        | **C**hange **S**urroundings                  | `cs'"` changes single quotes to double      |
| `yss`       | **Y**ank **S**urround **S**entence (entire line) | `yss<p>` wraps the current line in a `<p>` tag |

In Visual Mode, select text and type `s` followed by the character or tag (e.g., `s<em>`).

---

## Part 2: Text Object Mastery with Treesitter

Text objects are a cornerstone of Vim's efficiency. They give you a vocabulary to describe and manipulate blocks of code. Traditional text objects are based on characters (like `w` for word, `s` for sentence). **Treesitter makes them language-aware.**

A Treesitter text object understands what a "function", "class", or "parameter" is in the context of the specific programming language you're using.

### How It Works

The formula is `operator` + `text object`.

-   **Operators:** `d` (delete), `c` (change), `y` (yank/copy), `v` (visually select).
-   **Text Objects:** A two-character code that specifies the "thing" to act on. It usually starts with `a` (around/including) or `i` (inside/excluding).

### Your Configured Text Objects & Motions

Your `nvim-treesitter` configuration sets up powerful, language-aware text objects and motions.

#### Text Object Keymaps

These work with operators like `d`, `c`, `y`. For example, `daf` means "**d**elete **a**round **f**unction".

| Keymap | Meaning                               | Example Usage                                                              |
| ------ | ------------------------------------- | -------------------------------------------------------------------------- |
| `af`   | **A**round **F**unction               | `yaf` copies the entire function, including its signature and closing brace. |
| `if`   | **I**nside **F**unction               | `cif` deletes the content inside a function, leaving the signature.        |
| `ac`   | **A**round **C**lass                  | `vac` visually selects the entire class definition.                        |
| `ic`   | **I**nside **C**lass                  | `cic` changes the contents of a class.                                     |
| `aa`   | **A**round **A**rgument/Parameter     | `daa` deletes the argument your cursor is on, including the comma.         |
| `ia`   | **I**nside **A**rgument/Parameter     | `cia` changes the argument your cursor is on.                              |
| `at`   | **A**round **T**ag (HTML/XML)         | `dat` deletes an entire HTML tag, including its content.                   |
| `it`   | **I**nside **T**ag (HTML/XML)         | `cit` changes the content inside an HTML tag.                              |

#### Movement Keymaps

These keymaps allow you to jump between code blocks.

| Keymap | Action                               |
| ------ | ------------------------------------ |
| `]m`   | Go to **next** function **start**    |
| `[m`   | Go to **previous** function **start**|
| `]M`   | Go to **next** function **end**      |
| `[M`   | Go to **previous** function **end**  |
| `]]`   | Go to **next** class **start**       |
| `[[`   | Go to **previous** class **start**   |
| `][`   | Go to **next** class **end**         |
| `[]`   | Go to **previous** class **end**     |

### Practical Examples Across Languages

-   **Python:** You have a function `def my_func(a, b):`. Place your cursor on `a`.
    -   `cia` -> Change just `a`.
    -   `daa` -> Delete `a, `.
    -   `cif` -> Change the entire body of `my_func`.

-   **JavaScript/TypeScript:** You have a class `class MyClass { ... }`.
    -   `vac` -> Select the entire class.
    -   `]]` -> Jump to the start of the next class in the file.

-   **Go:** You have a struct `type User struct { ... }`.
    -   Treesitter understands this as a class-like structure. `vic` will select the fields inside the struct.

-   **HTML:** You have `<div><p>Hello</p></div>`.
    -   Cursor on `<p>`: `dat` deletes the entire `<p>Hello</p>`.
    -   Cursor on `Hello`: `cit` changes "Hello" but leaves the `<p>` tags.
    -   Cursor on `<div>`: `dat` deletes the entire `<div>...</div>` block.
