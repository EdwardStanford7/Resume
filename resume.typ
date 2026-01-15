

#let _navy_blue = rgb("#001f8f")

#let _big_bullets = false
#let _bullets = false
#let _lines = true
#let _top_line = false
#let _left_titles = false
#let _date_parens = false
#let _line_above = true
#let _centered_header = false
#let _no_links = false
#let _base_font_size = 8.1pt
#let _density = 0.8
#let _diff = 1.2
#let _use_link_symbol = true
#let _use_link_symbol_for_header = false
#let _block_body_indentation = 3
#let _dark_mode = true

#let _black = rgb("#151515")
#let _darkmode_white = rgb("#eee")



#let _link_color = if _dark_mode {
  rgb("#eae")
} else {
  _navy_blue
}

#let _block_title_color = if _dark_mode {
  _darkmode_white
} else {
  _black
}
#let _page_background = if _dark_mode {
  _black
} else {
  white
}

#let _text_color = if _dark_mode {
  _darkmode_white
} else {
  _black
}

#set page(
  margin: (
    top: 1cm,
    bottom: 1cm,
    left: 1cm,
    right: 1cm
  ),
  fill: _page_background
)

#let _link_symbol = "↗" //"🔗"
#set text(
  _text_color,
  font: "DejaVu Sans",
  _base_font_size,
)
#set par(
  leading: _base_font_size * _density,
  spacing: _base_font_size * _density
)
#let _item_font_size = _base_font_size * _diff
#let _block_header_font_size = _item_font_size * _diff

#let _date(_content) = {
  if _date_parens and _content != [] {
    [~(#_content)]
  } else {
    h(1fr)
    _content
  }
}

#let _true_link(_content, _subcontent, _url, _time) = {
  [
    #link(_url)[
      #text(_link_color)[
        *#_content*
        #emph(_subcontent)
        #if _use_link_symbol {
          _link_symbol
        }
      ]
    ]
  ]
  _date(_time)
}

#let _nolink(_content, _subcontent, _time) = {
  [*#_content* #emph(_subcontent)]
  _date(_time)
}

#let _link(_content, _subcontent, _url, _time) = {
  if _no_links {
    _nolink(_content, _subcontent, _time)
  } else {
    _true_link(_content, _subcontent, _url, _time)
  }
}

//ITEMS
#let _item_bullets(_title, _contents) = {
  if _bullets and _big_bullets {
    list(
      text(
        size: _item_font_size,
        _title
      ),
      indent: 0pt,
    )
  } else {
    text(size: _item_font_size, _title)
  }
  for _one_subitem in _contents {
    list(_one_subitem, indent: _base_font_size)
  }
  if _contents.len() == 0 and not _big_bullets {
    v(0pt)
  }
}

#let _subitem_no_bullets(_content) = {
  [#h(10pt) #_content]
}

#let _item_no_bullets(_title, _contents) = {
  text(size: _item_font_size, _title)
  if _contents.len() != 0 {
    v(0pt)
  }
  _contents.map(_subitem_no_bullets).join(v(0pt))
}

#let _item(_title, _contents) = {
  if _bullets {
    _item_bullets(_title, _contents)
  } else {
    _item_no_bullets(_title, _contents)
  }
}

//BLOCK

#let _block_left_title(_title, _items, _join) = {
  grid(columns: (1fr, 6fr),
    smallcaps(
      text(
        _block_title_color,
        size: _block_header_font_size,
        weight: "bold",
        _title,
      )
    ),
    block(
      inset: (top: _block_body_indentation/ 2 * _base_font_size),
      _items.join(_join)
    )
  )
}

#let _block_top_title(_title, _items, _join) = {
  if _lines and _line_above {
    line(length: 100%, stroke: 0.5pt + _text_color)
  }
  smallcaps(
    text(
      _block_title_color,
      size: _block_header_font_size,
      weight: "bold",
      _title,
    )
  )
  if _lines {
    if not _line_above {
      line(length: 100%, stroke: 0.5pt + _text_color)
    }
  } else {
    v(_base_font_size * _density)
  }
  block(
      inset: (left: _block_body_indentation * _base_font_size),
      _items.join(_join)
  )
}

#let _block(_title, _items) = {
  if _left_titles {
    _block_left_title(_title, _items, v(0pt))
  } else {
    _block_top_title(_title, _items, v(0pt))
  }
}

//RESUME

#let _all_blocks_no_lines(_blocks) = {
  if _blocks.len() != 0 and _top_line and not _line_above {
    line(length: 100%, stroke: 1pt + _text_color)
  }
  if _blocks.len() != 0 and _left_titles {v(_base_font_size * _density)}
  if _left_titles {
      _blocks.join(v(_base_font_size * _density))
  } else {
    _blocks.join(v(_base_font_size * _density))
  }
}

#let _all_blocks_lines(_blocks) = {
  if _blocks.len() != 0 and _top_line and not _line_above  {
    line(length: 100%, stroke: 1pt + _text_color)
  }
  if _left_titles {
    _blocks.join(line(length: 100%, stroke: 0.2pt + _text_color))
  } else {
    _blocks.join(v(_base_font_size * _density))
  }
}

#let _true_header_link(_ghlink) = {
  link("https://github.com/" + _ghlink)[
    #text(_link_color)[
      *github.com/#_ghlink*
      #if _use_link_symbol_for_header {
        _link_symbol
      }
    ]
  ]
}

#let _no_header_link(_ghlink) = {
  link("https://github.com/" + _ghlink)[
    *github.com/#_ghlink*
    #if _use_link_symbol_for_header {
      _link_symbol
    }
  ]
}

#let _header_link(_ghlink) = {
  if _no_links {
    _no_header_link(_ghlink)
  } else {
    _true_header_link(_ghlink)
  }
}

#let _resume(_name, _ghlink, _email, _phone, _blocks) = {  
  if _centered_header {
    align(center)[#smallcaps[#text(size: 18pt)[*#_name*]]]
    columns(3)[
      #align(left)[#_email]
      #colbreak()
      #align(center)[
        #_header_link(_ghlink)
      ]
      #colbreak()
      #align(right)[#_phone]
    ]
  } else {
    grid(columns: (1fr, 1fr),
      smallcaps[#text(size: 32pt)[*#_name*]],
      smallcaps[
        #h(1fr) #_header_link(_ghlink)\
        #h(1fr) #_phone\
        #h(1fr) #_email
      ]
    )
  }
  
  if _lines {
    _all_blocks_lines(_blocks) 
  } else {
    _all_blocks_no_lines(_blocks) 
  }
}

#_resume(
  [Robert Morelli],
  "robertmorelli",
  [robertondino\@outlook.com],
  [385 315 0034],
  (
    _block([Education],
      (
        _item(
          _nolink(
            [B.S. Computer Science (in progress)],
            [University of Utah],
            [2022 - 2027 _expected_]
          ),
          ()
        ),
        _item(
          _nolink(
            [A.S. Computer Science (incomplete)],
            [Salt Lake Community College],
            [2019 - 2022 _transferred_]
          ),
          ()
        ),
      )
    ),
    _block([Technology],
      (
        _item(
          _nolink(
            [Expert],
            [],
            []
          ),
          (
            [Zig, Dart, JS, WASM (WAT), CSS, SVG, GitHub Actions, MIPS asm],
          )
        ),
        _item(
          _nolink(
            [Proficient],
            [],
            []
          ),
          (
            [Angular, C, C\#, Cordova, Flutter, HTML, Java, Python, TS, Typst],
          )
        ),
        _item(
          _nolink(
            [Familiar],
            [],
            []
          ),
          (
            [Bash, C++, CICD, CircleCi, Laravel, Metal, MongoDB,  OpenCL, PHP, Ruby, Rust, Swift],
          )
        ),
      )
    ),
    _block([Experience],
      (
        _item(
          _nolink(
            [Research Assistant],
            [University of Utah],
            [Nov 2025 - present]
          ),
          (
            [Benchmarking gradual typing in Meta's Cinder variant of python],
          )
        ),
        _item(
          _nolink(
            [Teaching Assistant],
            [University of Utah],
            [Apr 2025 - present]
          ),
          (
            [Leading labs, grading, assisting students for COMP 1020],
          )
        ),
        _item(
          _nolink(
            [Software Engineer/Dev ops],
            [Stutor Inc.],
            [Sep 2023 - Apr 2024]
          ),
          (
            [Architected CICD pipeline],
            [Optimized DB indexes, reducing query times by up to 8x],
          )
        ),
        _item(
          _nolink(
            [Web Developer/Dev Ops],
            [Jerran Software Solutions],
            [Apr 2022 - Sep 2023]
          ),
          (
            [Overhauled LDS MTC QA/CICD workflow, substantially reducing regression burden],
            [Rewrote Embark app startup to reduce first time loading by up to 50%]
          )
        ),
        _item(
          _nolink(
            [Research Assistant Intern],
            [Earl Keefe PhD],
            [Nov 2020 - Jun 2021]
          ),
          (
            [Visualizations for anthropology research],
          )
        ),
        _item(
          _nolink(
            [Web Dev. Intern],
            [Frelii],
            [May 2019 - Sep 2019]
          ),
          (
            [Web scraping SNPedia for AI training],
          )
        ),
      )
    ),
    _block([Projects],
      (
        _item(
          _link(
            [Optimized bead/gravity sort],
            [zig],
            "https://github.com/robertmorelli/bead_sort_u5x32"
            ,[2026]
          ),
          (
            [Bead sort done via popcount intrinsics and bit matrix transpositions. Only for 32 u5s],
          )
        ),
        _item(
          _link(
            [Tiny nkey rollover tester OS],
            [zig],
            "https://github.com/robertmorelli/TinyNKRO.OS",
            [2025]
          ),
          (
            [Ported as OS class assignment to zig and then added keyboard input and vga output],
          )
        ),
        _item(
          _link(
            [Fast approximate change of base],
            [python],
            "https://github.com/robertmorelli/messy_print",
            [2025]
          ),
          (
            [Novel algorithm for printing numbers larger than $10^(10^5)$ efficiently],
          )
        ),
        _item(
          _link(
            [Automated resume],
            [typst],
            "https://robertmorelli.github.io/resume/",
            [2025]
          ),
          (
            [CICD typst resume],
          )
        ),
        _item(
          _link(
            [Held-karp],
            [zig],
            "https://github.com/robertmorelli/held_karp",
            [2025]
          ),
          (
            [Well optimized bitset based Held-karp TSP algorithm],
          )
        ),
        _item(
          _link(
            [Spreadsheet formulas to DLL compiler],
            [c],
            "https://github.com/robertmorelli/dll_compiler",
            [2025]
          ),
          (
            [A spreadsheet which compiles formulas to a DLL which can be used in DOTNET projects],
          )
        ),
        _item(
          _link(
            [Color alchemy],
            [qt c++],
            "https://robertmorelli.github.io/color_alchemy/",
            [2024]
          ),
          (
            [A game for learning color mixing],
          )
        ),
        _item(
          _link(
            [CSS grid examples],
            [css html],
            "https://robertmorelli.github.io/grid_examples/",
            [2024]
          ),
          (
            [Examples of common design patterns implemented with css grid as a good reference],
          )
        ),
        _item(
          _link(
            [Randomized Pacman game],
            [java],
            "https://github.com/robertmorelli/randomized_pacman",
            [2021]
          ),
          (
            [Pacman game using some algorithms from my 2420 class: A\*, DFS, BFS, Union find],
          )
        )
      ),
    ),
    _block([Misc],
      (
        
        _item(
          _link(
            [Added code field to instruction decoder],
            [MARS IDE],
            "https://github.com/dpetersanderson/MARS",
            [2025]
          ),
          (),
        ),
        _item(
          _link(
            [\#12 Ranked team at Rocky Mountain Regional Contest],
            [ICPC],
            "https://rmc25.kattis.com/contests/rmc25/standings/site",
            [2025]
          ),
          (),
        ),
        _item(
          _nolink(
            [Jane Street Leaderboard],
            [],
            []
          ),
          (
            _link(
              [Number Cross 5],
              [],
              "https://www.janestreet.com/puzzles/number-cross-5-solution/",
              [May 2025]
            ),
            _link(
              [Sum One, Somewhere],
              [],
              "https://www.janestreet.com/puzzles/sum-one-somewhere-solution/",
              [Apr 2025]
            ),
          )
        ),
      )
    ),
  )
)
