''
' ANSI LIB
'
' USAGE:
'   Insert '$INCLUDE:'path_to/ANSI.BI' at the top of file
'   Insert '$INCLUDE:'path_to/ANSI.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses ANSI.BM
'

DECLARE FUNCTION ansi_home$ ()
DECLARE FUNCTION ansi_locate$ (col%, row%)
DECLARE FUNCTION ansi_move_up$ (n%)
DECLARE FUNCTION ansi_move_down$ (n%)
DECLARE FUNCTION ansi_move_right$ (n%)
DECLARE FUNCTION ansi_move_left$ (n%)
DECLARE FUNCTION ansi_move_lines_down$ (n%)
DECLARE FUNCTION ansi_move_lines_up$ (n%)
DECLARE FUNCTION ansi_move_column$ (n%)
DECLARE FUNCTION ansi_fg_256$ (r%, g%, b%)
DECLARE FUNCTION ansi_bg_256$ (r%, g%, b%)

