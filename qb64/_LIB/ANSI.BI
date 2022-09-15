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

DIM SHARED ansi_x%  ' Cursor x position
DIM SHARED ansi_y%  ' Cursor y position

DECLARE FUNCTION ansi_home$ ()
DECLARE FUNCTION ansi_locate$ (col%, row%)
DECLARE FUNCTION ansi_move_up$ (n%)
DECLARE FUNCTION ansi_move_down$ (n%)
DECLARE FUNCTION ansi_move_right$ (n%)
DECLARE FUNCTION ansi_move_left$ (n%)
DECLARE FUNCTION ansi_move_lines_down$ (n%)
DECLARE FUNCTION ansi_move_lines_up$ (n%)
DECLARE FUNCTION ansi_move_column$ (n%)
DECLARE FUNCTION ansi_move_line_up$ ()
DECLARE FUNCTION ansi_save_pos$ ()
DECLARE FUNCTION ansi_restore_pos$ ()

DECLARE FUNCTION ansi_erase_to_eos$ ()
DECLARE FUNCTION ansi_erase_to_bos$ ()
DECLARE FUNCTION ansi_erase_screen$ ()
DECLARE FUNCTION ansi_erase_to_eol$ ()
DECLARE FUNCTION ansi_erase_from_sol$ ()
DECLARE FUNCTION ansi_erase_line$ ()

DECLARE FUNCTION ansi_fg_black$ ()
DECLARE FUNCTION ansi_fg_blue$ ()
DECLARE FUNCTION ansi_fg_green$ ()
DECLARE FUNCTION ansi_fg_cyan$ ()
DECLARE FUNCTION ansi_fg_red$ ()
DECLARE FUNCTION ansi_fg_magenta$ ()
DECLARE FUNCTION ansi_fg_yellow$ ()
DECLARE FUNCTION ansi_fg_white$ ()
DECLARE FUNCTION ansi_fg_bright_black$ ()
DECLARE FUNCTION ansi_fg_bright_blue$ ()
DECLARE FUNCTION ansi_fg_bright_green$ ()
DECLARE FUNCTION ansi_fg_bright_cyan$ ()
DECLARE FUNCTION ansi_fg_bright_red$ ()
DECLARE FUNCTION ansi_fg_bright_magenta$ ()
DECLARE FUNCTION ansi_fg_bright_yellow$ ()
DECLARE FUNCTION ansi_fg_bright_white$ ()

DECLARE FUNCTION ansi_fg_256$ (r%, g%, b%)
DECLARE FUNCTION ansi_bg_256$ (r%, g%, b%)

