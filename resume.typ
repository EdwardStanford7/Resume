

#let _navy_blue = rgb("#001f8f")

#let _big_bullets = false
#let _bullets = true
#let _lines = true
#let _top_line = false
#let _left_titles = false
#let _date_parens = false
#let _line_above = true
#let _centered_header = false
#let _no_links = false
#let _base_font_size = 7.75pt
#let _density = 0.75
#let _diff = 1.2
#let _use_link_symbol = true
#let _use_link_symbol_for_header = false
#let _block_body_indentation = 3
#let _dark_mode = false

#let _black = rgb("#151515")
#let _darkmode_white = rgb("#eee")



#let _link_color = if _dark_mode {
  rgb("#f983f9")
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

#let _link_symbol = [
  ~#box(
    image(
      "assets/link.png",
      width: .75em,
      height: .75em,
    ),
    baseline: .1em,
  )
]

#set text(
  _text_color,
  font: "Times New Roman",
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
        #h(1fr) #_email\
        #h(1fr) #_phone
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
  [Edward Stanford],
  "edwardstanford7",
  [edwardstanford7\@gmail.com],
  [801-651-4982],
  (
    _block([Education],
      (
        _item(
          _nolink(
            [M.S. Computer Science],
            [University of Utah],
            [2025 - 2026 _expected_]
          ),
          ()
        ),
        _item(
          _nolink(
            [B.S. Computer Science, Mathematics Minor],
            [University of Utah],
            [2021 - 2025]
          ),
          ()
        ),
         _item(
          _nolink(
            [Certificate in Data Science],
            [University of Utah],
            [2021 - 2025]
          ),
          ()
        ),
      )
    ),
    _block([Awards & Honors],
      (
        _item(
          _nolink(
            [Grateful Alumni Scholarship],
            [University of Utah],
            [Fall 2024]
          ),
          ()
        ),
        _item(
          _nolink(
            [Kiri Wagstaff AI/ML Scholarship],
            [University of Utah],
            [Fall 2024]
          ),
          ()
        ),
        _item(
          _nolink(
            [Richard B. & Brenda R. Brown Endowed Scholarship],
            [University of Utah],
            [Fall 2024]
          ),
          ()
        ),
        _item(
          _nolink(
            [College of Engineering Departmental Scholarship],
            [University of Utah],
            [Fall 2023, Spring 2024]
          ),
          ()
        ),
        _item(
          _nolink(
            [Dean's List],
            [University of Utah],
            [2021 - 2025 _(all semesters)_]
          ),
          ()
        ),
      )
    ),
    _block([Experience],
      (
        _item(
          _nolink(
          [Computer Systems Teaching Assistant],
          [University of Utah],
          [January 2026 - Present]
          ),
          (
            [Helped over 175 students by managing Piazza discussions, grading
          assignments, and provided detailed feedback on student submissions.],
          [Ran labs and held help hours for students to address questions and
          clarify concepts.],
          )
        ),
        // _item(
        //   _nolink(
        //   [Capstone Teaching Assistant],
        //   [University of Utah],
        //   [August 2025 - December 2025]
        //   ),
        //   (
        //     [Met weekly with student teams to provide specific feedback on
        //   projects.],
        //   [Assisted in maintaining course materials, and graded assignments.],
        //   )
        // ),
        _item(
          _nolink(
            [Software Practice II Teaching Assistant],
            [University of Utah],
            [August 2023 - May 2025]
          ),
          (
            [Supported over 200 students by managing Piazza discussions, grading
          assignments, and provided detailed feedback on student submissions.],
          [Ran labs and held help hours for students to address questions and
          clarify concepts.],
          )
        ),
        _item(
          _nolink(
            [GREAT Elementary School Summer Camp Instructor],
            [University of Utah],
            [June 2024 - July 2024]
          ),
          (
            [Taught robotics concepts to elementary students with hands-on
          activities.],
            [Supervised a structured learning environment for children.],
          )
        ),
        // _item(
        //   _nolink(
        //     [Undergraduate Research Assistant],
        //     [University of Utah],
        //     [March 2022 - July 2022]
        //   ),
        //   (
        //     [Simulated micro-fibers and fibrous materials using SOLIDWORKS to
        //   contribute to research projects.],
        //     [Authored comprehensive technical reports with LaTeX to document
        //   research findings and methodologies.],
        //   )
        // ),
      )
    ),
     _block([Projects],
      (
        _item(
          _nolink(
        [Full Stack Photo Sharing App (Capstone Project) - BeThere],
        [C\#, React],
        [August 2024 – Present]
          ),
          (
        [Developed a backend server with a modular REST API to handle photo uploads, user management, and clustering based on geolocation data.],
        [Integrated PostgreSQL for robust data storage with LINQ, and built access control linking users to clusters for selective album visibility by location.],
          )
        ),
        _item(
          _nolink(
        [Full JPL Compiler],
        [C++, Rust],
        [January 2025 – May 2025]
          ),
          (
        [Developed a full compiler for the JPL programming language.],
        [Implemented the full pipeline (lexing, parsing, semantic analysis, optimization, codegen) including type checking, scope management, and code optimizations.],
          )
        ),
        _item(
          _link(
        [Rust GUI for ELO Media Ratings],
        [Rust],
        "https://github.com/EdwardStanford7/media_rating",
        [July 2024 - Present]
          ),
          (
        [Implemented an Elo rating system for media ranking and viewing using egui.],
        [Added data persistence with spreadsheet output, plus automated image fetching and UI integration for a smoother workflow.],
          )
      ),
        _item(
          _link(
        [Path of Memories Gamejam],
        [C\# with Unity],
        "https://github.com/EdwardStanford7/Path-of-Memories",
        [January 2023]
          ),
          (
        [Built a 2D platformer featuring a robust dialogue system, player progression tracking, and character-driven interactions/level design.],
        [Added diverse player abilities including wall climbing, double jumping, and dashing.],
          )
        ),
        // _item(
        //   _link(
        // [Scamper Gamejam],
        // [C\# with Unity],
        // "https://github.com/Jakeo915/ScamperGameJam",
        // [October 2022]
        //   ),
        //   (
        // [Developed 2D side-scrolling mechanics with advanced jump buffer and coyote time for seamless player control.],
        // [Managed layer transitions/animations and collaborated with a team to integrate game assets and maintain cohesive design.],
        //   )
        // ),
        // _item(
        //   _nolink(
        // [Prime in Five Gamejam],
        // [C\# with Unity],
        // [September 2022]
        //   ),
        //   (
        // [Created a dynamic gameplay experience with AI, procedural enemy generation, and complex health systems.],
        // [Programmed top-down movement, a timer-based win condition, and player interactions to ensure engaging gameplay flow.],
        //   )
        // ),
        _item(
          _nolink(
        [Circuit Simulator QT Application],
        [C++],
        [April 2023]
          ),
          (
        [Designed an educational circuit-logic game with an intuitive, interactive UI and user-customizable gates.],
        [Implemented save functionality using JSON for persistent user data.],
          )
        ),
        _item(
          _nolink(
        [LMS Website],
        [C\#],
        [April 2023]
          ),
          (
        [Developed a learning management system leveraging a MariaDB backend.],
        [Ensured seamless front-end/back-end integration using .NET technologies, including user authentication and course management.],
          )
        ),
        _item(
          _nolink(
        [Sprite Editor QT Application],
        [C++],
        [March 2023]
          ),
          (
        [Created a comprehensive sprite editor with detailed UI and user interactions.],
        [Supported multiple image formats/export options and implemented advanced drawing tools with color manipulation features.],
          )
        ),
        _item(
          _nolink(
        [Snake Network Game],
        [C\#],
        [October 2022 – December 2022]
          ),
          (
        [Built a networked snake game with distinct server and client implementations.],
        [Managed multiplayer functionality with real-time synchronization.], 
          )
        ),
        // _item(
        //   _nolink(
        // [Spreadsheet Application],
        // [C\#],
        // [August 2022 – October 2022]
        //   ),
        //   (
        // [Developed a user-friendly spreadsheet tool following the MVC design pattern.],
        // [Integrated .NET MAUI for cross-platform compatibility and enhanced UX with interactive data manipulation.],
        //   )
        // ),
        // _item(
        //   _nolink(
        // [Tower Defense Game],
        // [Java],
        // [October 2021 – May 2022]
        //   ),
        //   (
        // [Designed a tower defense game employing OOP concepts like inheritance and polymorphism.],
        // [Balanced gameplay mechanics for progressive difficulty scaling.],  
        //   )
        // ),
      )
        ),
        _block([Misc],
      (
        _item(
          _link(
        [Advent of Code 2025],
        [Rust],
        "https://github.com/EdwardStanford7/advent_of_code_2025",
        [December 2025 - January 2026]
          ),
          (
        [Solved 22 challenges focusing on dynamic programming, graph algorithms, and geometric problems.],
        [Improved Rust proficiency while implementing efficient data structures/algorithms to optimize solution performance.],
          )
        ),
        // _item(
        //   _nolink(
        // [Advent of Code 2020],
        // [C++],
        // [December 2020 – May 2022]
        //   ),
        //   (
        // [Solved 48 challenges focusing on recursion, encryption, and data structures.],
        // [Enhanced problem-solving skills while applying OOP principles to build modular and maintainable solutions.],
        //   )
        // ),
        _item(
          _nolink(
        [Project Euler],
        [C++, Python],
        [August 2020 – December 2020]
          ),
          (
        [Tackled 59 mathematics and computation-intensive problems.],
        [Employed efficient algorithms for large-scale numerical challenges, strengthening mathematical reasoning and coding proficiency.],
          )
        ),
      )
        ),
        _block([Technology],
      (
        _item(
          _nolink(
        [Experienced],
        [],
        []
          ),
          (
        [C++, Rust, C, C\#, SQL, VSCode, Qt, Docker, Linux, MacOS],
          )
        ),
        _item(
          _nolink(
        [Proficient],
        [],
        []
          ),
          (
        [Python, Java, Latex, Typst, R, Git, MS Visual Studio, MS Office, XCode],
          )
        ),
      )
        ),
      )
    )
