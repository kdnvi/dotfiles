" extends the built-in unokai with treesitter (@) highlight groups.
source $VIMRUNTIME/colors/unokai.vim
let g:colors_name = 'monokai'

" --- general ---------------------------------------------------------------
hi! link @annotation                               Type
hi! link @attribute                                Type
hi! link @boolean                                  Constant
hi! link @character                                Character
hi! link @character.special                        SpecialChar
hi! link @conceal                                  Conceal
hi! link @debug                                    Debug
hi! link @error                                    Error
hi! link @exception                                Exception
hi! link @float                                    Float
hi! link @label                                    Label
hi! link @math                                     Special
hi! link @nospell                                  Ignore
hi! link @operator                                 Operator
hi! link @property                                 Normal
hi! link @reference                                Normal
hi! link @scope                                    Normal
hi! link @spell                                    Comment
hi! link @spell.markdown                           Normal
hi! link @spell.markdown_inline                    Normal
hi! link @strike                                   Comment
hi! link @symbol                                   Constant
hi! link @todo                                     Todo
hi! link @uri                                      Identifier

" --- comment ---------------------------------------------------------------
hi! link @comment                                  Comment
hi! link @comment.documentation                    Comment
hi! link @comment.error                            Error
hi! link @comment.note                             Todo
hi! link @comment.warning                          WarningMsg

" --- constant --------------------------------------------------------------
hi! link @constant                                 Constant
hi! link @constant.builtin                         Constant
hi! link @constant.macro                           Macro

" --- definition ------------------------------------------------------------
hi! link @definition                               Normal
hi! link @definition.associated                    Normal
hi! link @definition.constant                      Constant
hi! link @definition.enum                          Normal
hi! link @definition.field                         Normal
hi! link @field                                    Normal
hi! link @definition.function                      Function
hi! link @definition.import                        PreProc
hi! link @definition.macro                         Macro
hi! link @definition.method                        Function
hi! link @definition.namespace                     Normal
hi! link @definition.parameter                     Normal
hi! link @definition.type                          Identifier
hi! link @definition.var                           Normal

" --- function / method -----------------------------------------------------
hi! link @function                                 Function
hi! link @function.builtin                         Function
hi! link @function.call                            Normal
hi! link @function.macro                           Macro
hi! link @function.method                          Function
hi! link @function.method.call                     Normal
hi! link @method                                   Function
hi! link @method.call                              Normal
hi! link @constructor                              Function

" --- keyword / preprocessor ------------------------------------------------
hi! link @define                                   Define
hi! link @include                                  PreProc
hi! link @keyword                                  Keyword
hi! link @keyword.conditional                      Conditional
hi! link @keyword.conditional.ternary              Conditional
hi! link @keyword.coroutine                        Keyword
hi! link @keyword.directive                        PreProc
hi! link @keyword.directive.define                 Define
hi! link @keyword.exception                        Exception
hi! link @keyword.function                         Keyword
hi! link @keyword.import                           PreProc
hi! link @keyword.modifier                         Keyword
hi! link @keyword.operator                         Operator
hi! link @keyword.repeat                           Repeat
hi! link @keyword.return                           Keyword
hi! link @keyword.type                             Keyword
hi! link @preproc                                  PreProc
hi! link @conditional                              Conditional
hi! link @conditional.ternary                      Conditional
hi! link @repeat                                   Repeat
hi! link @storageclass                             StorageClass
hi! link @storageclass.lifetime                    StorageClass

" --- markup (markdown) -----------------------------------------------------
hi! link @markup.heading                           @markup.heading.1
hi! link @markup.heading.1                         Statement
hi! link @markup.heading.1.delimiter               @markup.heading.1
hi! link @markup.heading.2                         Type
hi! link @markup.heading.2.delimiter               @markup.heading.2
hi! link @markup.heading.3                         String
hi! link @markup.heading.4                         Function
hi! link @markup.heading.5                         Identifier
hi! link @markup.heading.6                         Constant
hi! link @markup.raw                               String
hi! link @markup.raw.block                         String
hi! link @markup.link                              Underlined
hi! link @markup.link.label                        Underlined
hi! link @markup.link.url                          Underlined
hi! link @markup.quote                             Comment
hi! link @markup.list                              Comment
hi! link @markup.list.checked                      Comment
hi! link @markup.list.unchecked                    Comment
hi! link @markup.strikethrough                     Comment
hi! link @markup.strong                            Title
hi! link @markup.italic                            htmlItalic
hi! link markdownCode                              String

" --- module / namespace ----------------------------------------------------
hi! link @module                                   Identifier
hi! link @module.builtin                           Special
hi! link @namespace                                Identifier

" --- number ----------------------------------------------------------------
hi! link @number                                   Number
hi! link @number.float                             Float

" --- parameter -------------------------------------------------------------
hi! link @parameter                                Normal
hi! link @parameter.reference                      Normal

" --- punctuation -----------------------------------------------------------
hi! link @punctuation.bracket                      Normal
hi! link @punctuation.delimiter                    Normal
hi! link @punctuation.special                      Special

" --- string ----------------------------------------------------------------
hi! link @string                                   String
hi! link @string.escape                            SpecialChar
hi! link @string.regex                             Special
hi! link @string.regexp                            Special
hi! link @string.special                           Special
hi! link @string.special.path                      Special
hi! link @string.special.url                       Underlined

" --- tag -------------------------------------------------------------------
hi! link @tag                                      Tag
hi! link @tag.attribute                            Identifier
hi! link @tag.delimiter                            Delimiter

" --- text ------------------------------------------------------------------
hi! link @text                                     Normal
hi! link @text.danger                              Error
hi! link @text.diff.add                            Added
hi! link @text.diff.delete                         Removed
hi! link @text.emphasis                            Normal
hi! link @text.environment                         Constant
hi! link @text.environment.name                    Function
hi! link @text.literal                             String
hi! link @text.math                                Special
hi! link @text.note                                Todo
hi! link @text.quote                               Comment
hi! link @text.reference                           Identifier
hi! link @text.strike                              Comment
hi! link @text.strong                              Normal
hi! link @text.title                               Title
hi! link @text.todo                                Todo
hi! link @text.underline                           Normal
hi! link @text.uri                                 Identifier
hi! link @text.warning                             WarningMsg

" --- type ------------------------------------------------------------------
hi! link @type                                     Normal
hi! link @type.builtin                             Normal
hi! link @type.definition                          Identifier
hi! link @type.qualifier                           Keyword

" --- variable --------------------------------------------------------------
hi! link @variable                                 Normal
hi! link @variable.builtin                         Identifier
hi! link @variable.member                          Normal
hi! link @variable.parameter                       Normal
hi! link @variable.parameter.builtin               Special
