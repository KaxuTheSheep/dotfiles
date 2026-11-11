-- amethyst: the vis theme. 
--   comment, line numbers   8        error                   9 (prominent failure)
--   keyword, function,      13       string, number, tag     10
--     class, definition              preprocessor            2
--   variable                5        constant, heading       15
--   type, attribute,        12       operator                7 (text)
--     label, regex                   diff: added 2, deleted 1, changed 3
--   unknown tag/attribute   3 (warn) selection               back 4, text 0 (D8)
--   cursor                  back 5 (accent), text 0
--   status bar              reverse video; unfocused is a dim (8) block
local lexers = vis.lexers
lexers.STYLE_DEFAULT = ''
lexers.STYLE_NOTHING = ''
lexers.STYLE_ATTRIBUTE = 'fore:12'
lexers.STYLE_CLASS = 'fore:13'
lexers.STYLE_COMMENT = 'fore:8'
lexers.STYLE_CONSTANT = 'fore:15'
lexers.STYLE_DEFINITION = 'fore:13'
lexers.STYLE_ERROR = 'fore:9'
lexers.STYLE_FUNCTION = 'fore:13'
lexers.STYLE_HEADING = 'fore:15'
lexers.STYLE_KEYWORD = 'fore:13'
lexers.STYLE_LABEL = 'fore:12'
lexers.STYLE_NUMBER = 'fore:10'
lexers.STYLE_OPERATOR = 'fore:7'
lexers.STYLE_REGEX = 'fore:12'
lexers.STYLE_STRING = 'fore:10'
lexers.STYLE_PREPROCESSOR = 'fore:2'
lexers.STYLE_TAG = 'fore:10'
lexers.STYLE_TYPE = 'fore:12'
lexers.STYLE_VARIABLE = 'fore:5'
lexers.STYLE_WHITESPACE = ''
lexers.STYLE_EMBEDDED = ''
lexers.STYLE_IDENTIFIER = ''

lexers.STYLE_LINENUMBER = 'fore:8'
lexers.STYLE_LINENUMBER_CURSOR = lexers.STYLE_LINENUMBER
lexers.STYLE_CURSOR = 'reverse'
lexers.STYLE_CURSOR_PRIMARY = 'back:5,fore:0'
lexers.STYLE_CURSOR_LINE = 'underlined'
lexers.STYLE_COLOR_COLUMN = 'back:8'
lexers.STYLE_SELECTION = 'back:4,fore:0'
lexers.STYLE_STATUS = 'fore:8,reverse'
lexers.STYLE_STATUS_FOCUSED = 'reverse'
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = ''
lexers.STYLE_EOF = ''

-- Diff
lexers.STYLE_ADDITION = 'fore:2'
lexers.STYLE_DELETION = 'fore:1'
lexers.STYLE_CHANGE = 'fore:3'

-- CSS
lexers.STYLE_PROPERTY = lexers.STYLE_ATTRIBUTE
lexers.STYLE_PSEUDOCLASS = ''
lexers.STYLE_PSEUDOELEMENT = ''

-- HTML (unknown is a warning, not italics)
lexers.STYLE_TAG_UNKNOWN = 'fore:3'
lexers.STYLE_ATTRIBUTE_UNKNOWN = 'fore:3'

-- Latex, TeX, Texinfo
lexers.STYLE_COMMAND = lexers.STYLE_KEYWORD
lexers.STYLE_COMMAND_SECTION = lexers.STYLE_CLASS
lexers.STYLE_ENVIRONMENT = lexers.STYLE_TYPE
lexers.STYLE_ENVIRONMENT_MATH = lexers.STYLE_NUMBER

-- Makefile
lexers.STYLE_TARGET = ''

-- Markdown
lexers.STYLE_HR = ''
for i = 1,6 do lexers['STYLE_HEADING_H'..i] = lexers.STYLE_HEADING end
lexers.STYLE_BOLD = 'fore:15'
lexers.STYLE_ITALIC = ''
lexers.STYLE_LIST = lexers.STYLE_KEYWORD
lexers.STYLE_LINK = lexers.STYLE_KEYWORD
lexers.STYLE_REFERENCE = lexers.STYLE_KEYWORD

-- Output
lexers.STYLE_FILENAME = 'fore:15'
lexers.STYLE_LINE = 'fore:8'
lexers.STYLE_COLUMN = 'fore:8'
lexers.STYLE_MESSAGE = ''

-- Python
lexers.STYLE_KEYWORD_SOFT = ''

-- Taskpaper
lexers.STYLE_NOTE = ''
lexers.STYLE_TAG_EXTENDED = ''
lexers.STYLE_TAG_DAY = 'fore:5'
lexers.STYLE_TAG_OVERDUE = 'fore:1'
lexers.STYLE_TAG_PLAIN = ''

-- XML
lexers.STYLE_CDATA = ''

-- YAML
lexers.STYLE_ERROR_INDENT = 'back:1'

-- Antlr
lexers.STYLE_ACTION = ''

-- Clojure
lexers.STYLE_CLOJURE_KEYWORD = lexers.STYLE_TYPE
lexers.STYLE_CLOJURE_SYMBOL = lexers.STYLE_TYPE

-- Gleam
lexers.STYLE_MODULE = lexers.STYLE_CONSTANT
lexers.STYLE_DISCARD = lexers.STYLE_COMMENT

-- Icon
lexers.STYLE_SPECIAL_KEYWORD = lexers.STYLE_TYPE

-- jq
lexers.STYLE_FORMAT = lexers.STYLE_CONSTANT
lexers.STYLE_SYSVAR = lexers.STYLE_CONSTANT

-- Julia
lexers.STYLE_CHARACTER = lexers.STYLE_CONSTANT

-- Mediawiki
lexers.STYLE_BEHAVIOR_SWITCH = lexers.STYLE_KEYWORD

-- Moonscript
lexers.STYLE_TBL_KEY = lexers.STYLE_REGEX
lexers.STYLE_SELF_REF = lexers.STYLE_LABEL
lexers.STYLE_PROPER_IDENT = lexers.STYLE_CLASS
lexers.STYLE_FNDEF = lexers.STYLE_PREPROCESSOR

-- reST
lexers.STYLE_LITERAL_BLOCK = lexers.STYLE_EMBEDDED
lexers.STYLE_FOOTNOTE_BLOCK = lexers.STYLE_LABEL
lexers.STYLE_CITATION_BLOCK = lexers.STYLE_LABEL
lexers.STYLE_LINK_BLOCK = lexers.STYLE_LABEL
lexers.STYLE_CODE_BLOCK = lexers.STYLE_EMBEDDED
lexers.STYLE_DIRECTIVE = lexers.STYLE_KEYWORD
lexers.STYLE_SPHINX_DIRECTIVE = lexers.STYLE_KEYWORD
lexers.STYLE_UNKNOWN_DIRECTIVE = lexers.STYLE_KEYWORD
lexers.STYLE_SUBSTITUTION = lexers.STYLE_VARIABLE
lexers.STYLE_INLINE_LITERAL = lexers.STYLE_EMBEDDED
lexers.STYLE_ROLE = lexers.STYLE_CLASS
lexers.STYLE_INTERPRETED = lexers.STYLE_STRING

-- txt2tags
-- (txt2tags reuses STYLE_LINE; it keeps the dim style above. It was 'bold' before.)
for i = 1,5 do lexers['STYLE_H'..i] = lexers.STYLE_HEADING end
lexers.STYLE_IMAGE = 'fore:4'
lexers.STYLE_STRIKE = ''
lexers.STYLE_TAGGED = lexers.STYLE_EMBEDDED
lexers.STYLE_TAGGED_AREA = lexers.STYLE_EMBEDDED
lexers.STYLE_TABLE_SEP = 'fore:4'
lexers.STYLE_HEADER_CELL_CONTENT = 'fore:4'
