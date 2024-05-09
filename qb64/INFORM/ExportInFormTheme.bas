$DEBUG
OPTION _EXPLICIT

CONST __HASHTABLE_FALSE%% = 0%%, __HASHTABLE_TRUE%% = NOT __HASHTABLE_FALSE
CONST __HASHTABLE_KEY_EXISTS& = -1&
CONST __HASHTABLE_KEY_UNAVAILABLE& = -2&

' Hash table entry type
' To extended supported data types, add other value types after V and then write
' wrappers around __HashTable_GetInsertIndex() & __HashTable_GetLookupIndex()
TYPE HashTableType
    U AS _BYTE ' used?
    K AS _UNSIGNED LONG ' key
    V AS LONG ' value
END TYPE

CONST __INFORM_THEME_IMAGE_ARROWS~%% = 1~%%
CONST __INFORM_THEME_IMAGE_BUTTON~%% = 2~%%
CONST __INFORM_THEME_IMAGE_CHECKBOX~%% = 3~%%
CONST __INFORM_THEME_IMAGE_FRAME~%% = 4~%%
CONST __INFORM_THEME_IMAGE_MENUCHECKMARK~%% = 5~%%
CONST __INFORM_THEME_IMAGE_NOTFOUND~%% = 6~%%
CONST __INFORM_THEME_IMAGE_PROGRESSCHUNK~%% = 7~%%
CONST __INFORM_THEME_IMAGE_PROGRESSTRACK~%% = 8~%%
CONST __INFORM_THEME_IMAGE_RADIOBUTTON~%% = 9~%%
CONST __INFORM_THEME_IMAGE_SCROLLBUTTONS~%% = 10~%%
CONST __INFORM_THEME_IMAGE_SCROLLHBUTTONS~%% = 11~%%
CONST __INFORM_THEME_IMAGE_SCROLLHTHUMB~%% = 12~%%
CONST __INFORM_THEME_IMAGE_SCROLLHTRACK~%% = 13~%%
CONST __INFORM_THEME_IMAGE_SCROLLTHUMB~%% = 14~%%
CONST __INFORM_THEME_IMAGE_SCROLLTRACK~%% = 15~%%
CONST __INFORM_THEME_IMAGE_SLIDERDOWN~%% = 16~%%
CONST __INFORM_THEME_IMAGE_SLIDERTRACK~%% = 17~%%

REDIM __UI_ThemeImages(0 TO 0) AS HashTableType

SCREEN _NEWIMAGE(640, 480, 32)

_SAVEIMAGE "ARROWS.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_ARROWS)
_SAVEIMAGE "BUTTON.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_BUTTON)
_SAVEIMAGE "CHECKBOX.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_CHECKBOX)
_SAVEIMAGE "FRAME.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_FRAME)
_SAVEIMAGE "MENUCHECKMARK.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_MENUCHECKMARK)
_SAVEIMAGE "NOTFOUND.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_NOTFOUND)
_SAVEIMAGE "PROGRESSCHUNK.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_PROGRESSCHUNK)
_SAVEIMAGE "PROGRESSTRACK.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_PROGRESSTRACK)
_SAVEIMAGE "RADIOBUTTON.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_RADIOBUTTON)
_SAVEIMAGE "SCROLLBUTTONS.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SCROLLBUTTONS)
_SAVEIMAGE "SCROLLHBUTTONS.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SCROLLHBUTTONS)
_SAVEIMAGE "SCROLLHTHUMB.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SCROLLHTHUMB)
_SAVEIMAGE "SCROLLHTRACK.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SCROLLHTRACK)
_SAVEIMAGE "SCROLLTHUMB.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SCROLLTHUMB)
_SAVEIMAGE "SCROLLTRACK.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SCROLLTRACK)
_SAVEIMAGE "SLIDERDOWN.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SLIDERDOWN)
_SAVEIMAGE "SLIDERTRACK.bmp", __UI_LoadThemeImage(__INFORM_THEME_IMAGE_SLIDERTRACK)

END

FUNCTION __UI_LoadThemeImage& (id AS _UNSIGNED _BYTE)
    SHARED __UI_ThemeImages() AS HashTableType

    ' If we have already loaded the image, then simply return the handle
    IF HashTable_IsKeyPresent(__UI_ThemeImages(), id) THEN
        __UI_LoadThemeImage = HashTable_LookupLong(__UI_ThemeImages(), id)
        EXIT FUNCTION
    END IF

    ' Else we will decode it from memory
    DIM imageHandle AS LONG: imageHandle = _LOADIMAGE(__UI_ImageData(id), 32, "memory")

    IF imageHandle < -1 THEN
        HashTable_InsertLong __UI_ThemeImages(), id, imageHandle
        __UI_LoadThemeImage = imageHandle
    ELSE
        ERROR 51
    END IF
END FUNCTION

FUNCTION __UI_ImageData$ (id AS _UNSIGNED _BYTE)
    SELECT CASE id
        CASE __INFORM_THEME_IMAGE_ARROWS
            CONST SIZE_ARROWS_BMP_5306~& = 5306~&
            CONST COMP_ARROWS_BMP_5306%% = -1%%
            CONST DATA_ARROWS_BMP_5306 = _
                "eNpy8t0lwgAGVUCcA8ScQDwBiBkZFBiYGXCB/xAE45AEYJr+/4fhx6e3g2hMjJAH4QFWR395wuGDwC3V2YTkQXgg1dFXHlMdHcJwNAyLU6IB7ZcB" + _
                "BgAACAP//+vAADlwJsIhKzIakR5afb7O/iCXsqnVRx5euqtW33voe3gpmwp9pDNCZoZFhxrncH8f/97DokONc7C/wHso4GdmWHSocU7INBPOHyn/" + _
                "hH+4BN+Oerv+LyfwHgpw/kj5J//DzAC3fJnz"

            __UI_ImageData = Base64_LoadResourceString(DATA_ARROWS_BMP_5306, SIZE_ARROWS_BMP_5306, COMP_ARROWS_BMP_5306)

        CASE __INFORM_THEME_IMAGE_BUTTON
            CONST SIZE_BUTTON_BMP_7682~& = 7682~&
            CONST COMP_BUTTON_BMP_7682%% = -1%%
            CONST DATA_BUTTON_BMP_7682 = _
                "eNpy8mWSYwCDKiDOAWIhIM4EYkYGBQZmBlwA0I45MEmSRlH016wdWNu20WPbtm22bdu2bds27uZdvKioUL+xOuaMz2lV3fyy8O8P+YP+LSPUDX4/" + _
                "P3dT/N8IWPga/Fe9c0MELHoD0lzwCv8O0YcXImqfxazg/w3d9BFd6WQc/wlR+y1QGO2pgQ5d6WSe/MXoL0BZgr8KOnSlc+o3xBxZgpqMSA106Eon" + _
                "6/QfiDu2Ag258Srijq+gK53ss38h8cw6tBanaqBDVzq55+cg5cImdFblaTCczXSlk3dhHtKubMdgZ6MGOnSlU3BlEXLsDmC4v10DHbrSKbq+DPku" + _
                "pzE61K0i3/U0XekUW65Ascd5jI/1azCcc3SlU2K9EiXelzAxMaTBcC7SlU6pzWqU+1/D1NSYBjp0pVNmtxZVwdaYnp7UYDg2dKVTbr8edWH2mJmZ" + _
                "1kCHrnQqHDeiLtIVGBvUQIeuycezDnXhjjcCXekE7p6Pjsjd6Ig7oYIO3Qurvsat2uee9iakJ6fcDNK4yTfpPeo86jzqPOrgUeeW7TO3/vK673Hg" + _
                "uxew/9vnNBjO87i09ls2cGbxR3DbOQeYHr8hbIyP4ezST/hxIOL8FrnWagk/t0U+F3bk+q+DHTakI+cRJeYdOR8pMe/IeU2JeUfOj0rMO3KeVWLe" + _
                "kfO1EvOOnPeVmHfk/kOJeUfuh5SYd+T+TEnEhW2mHblX1BJxaadpR+5dtURc2WPakXtpLZHXD5h2kBvmckNEWR1iQ/aHX3f+qoFOlM1RNngWR9C5" + _
                "HeiqK0FXTZFB8SwpokNXzvOXN/wIbu3+b57RYDjP4fzKL9i46Z2/wI7Jzj++reJGoCs7zz9/5NGCuWH9sDCYOzvo0JXP5ZndlfgqoFX92KHzzK5K" + _
                "+TxfOlCNX4LbtI9lw2k13CrpvHa8BvMj2tXPrXmG8+rxGum8d64Oq2I71c91Ou+fr5PO59cbsC25W7092w3HcKXzo0MzjmT0qLfwsOH86NgkHQvP" + _
                "VhzM6VVvMx0Lr1bpLA1ux/HCPvW1gs6y4DbpbIjpxJnSfvW1i86G2E7p7ErtxoXKAfW1lM7O1G7pHM7txZXaQe21nQ5d6Zwu7Ydl45D2rEGHrnQu" + _
                "1wzCpmVIe/ahQ1c6Vk1DsG8b1p7F6NCVDv98gx0iO8/fE37NFIhnsvPyd1ru9Z3Pcj2LbDcddEx3Pt/7KppKs7XXZDp05XPJ97mKjvpy9c7TocsG" + _
                "KfC3Qmd9uXbn6dCVTmGgHbobq7Q7T4eudIqDHdHTXKPdeTp0pVMa4Ya+tgbtztOhK52KaC/0dzRpd54OXelUxflhsKtVu/N06EqnPi0Mo33d2p2n" + _
                "Q1c6TTnxmBge0O48HbrSac1PwuTIoHbn6dCVTltRKqbGhrU7T4eudDpLMzE9PqLdeTp0pdNdmYuZiTHtztOhK52+6gJgaly7z3ToSqe/rhQw+srX" + _
                "AOjQlZ0fbqsFJsfUr0nQoXsvnuf/Bu9ttOA="

            __UI_ImageData = Base64_LoadResourceString(DATA_BUTTON_BMP_7682, SIZE_BUTTON_BMP_7682, COMP_BUTTON_BMP_7682)

        CASE __INFORM_THEME_IMAGE_CHECKBOX
            CONST SIZE_CHECKBOX_BMP_5530~& = 5530~&
            CONST COMP_CHECKBOX_BMP_5530%% = -1%%
            CONST DATA_CHECKBOX_BMP_5530 = _
                "eNpy8p0lygAGVUCcA8S8QJwBxIwMCgzMDLjAfwiCccgAJ48e+08OJgUA2q0HGNmSKAzAsa2xYq9tb7DeaDdc27YdrO1n27bttj3W5f+6kvyZm9Tr" + _
                "qnrmJM1b39Spc27S/zE0/M7USDVrjPKsGiN5ndHVadI3Q6Ps4wmd6RE8Prin+Yge63bvxaYDIWyNxLAzkcKeTBb780WEShVEKl2IdfXwQYPV23cY" + _
                "O5plmzYHHZq+aanpaBauWUuHxs+a0fhVc01HM2f5cuHQ8GETGj5pUjqa6QsXCYf6dxuFU+5HM3nuXOFQ/1aDtk6aCTNn0rFOybGfNGOnTdM6ziFo" + _
                "NI5zkIyJozlRj4fXOXhgtY0Hq48XNjl4fYuDx9fZuHWRhSvnWrh0zjAumjWM82cO0+Dp6rqnNjh4a5uDX0MuxsU9fLfv0I7mrR0uPt/jYmh4GJZt" + _
                "o+PfDvEqPqN/cBB9/f10NPgx5GFSyuN68ZAc96P5P+5jacEPrJcd66QZn/KxsuQH10mO56OZnfOxtuwH/6/kRF9EP2kWVetaVTWB+iU3MeHh7W0j" + _
                "ZnEREG5gaIh9ktyUlIcPdoyYNRVgQQGYlPbxR8zHN/s9fLnPA/s5J+vhv6gHMT+ard1Qup/DnpifmPsJv0d7+vrQNzCAwWoPhi0L4tyO68LzPPi+" + _
                "j+AfTVdPj7GjKXd1BZ3obU1HUyiX6TjDmo4mWywKx7VKR5PK5YTjOuV+NIlMRjhxXVsnTSyVomOdkmM/aSLJpNZxDkGjcZyDZAzcEd9rJz+PnjNn" + _
                "ljmXR+n0eVR2+jyqd3Ie1Ts5j+qdPo/KzjyP0p0defT+FTbuXGbj9sUWblpo4dr5yjxq7Ghe2eYKJ34/aj7oaN7Z6QqnNNyP5pM9nnBKwzppRO4S" + _
                "TmV4PhrmNZVhX2iY81SG/aRhPlQZzkGRR9kXzoHz0+ZR2Z34PMqM0R/IlrbjwFXkUWYTEydnS72jyeTzxo4mmckYO5poMmnsaELxuLGj2R+NGjua" + _
                "veGwsQsYUycZA3fE99pBQT3OQA=="

            __UI_ImageData = Base64_LoadResourceString(DATA_CHECKBOX_BMP_5530, SIZE_CHECKBOX_BMP_5530, COMP_CHECKBOX_BMP_5530)

        CASE __INFORM_THEME_IMAGE_FRAME
            CONST SIZE_FRAME_BMP_1882~& = 1882~&
            CONST COMP_FRAME_BMP_1882%% = -1%%
            CONST DATA_FRAME_BMP_1882 = _
                "eNpz8o1iZwCDKiDOAWIxIBYBYkYGBQZmBlzgPwTBOCQBmKb//0H45tVrFOP9Fy+CzUIzE8SmCB+5fBlsDqaZlOOjILMRZlITg8KDFuaCzBw1d9Tc" + _
                "UXNHzcVV7tCqnKRZuU6reggAlatSMg=="

            __UI_ImageData = Base64_LoadResourceString(DATA_FRAME_BMP_1882, SIZE_FRAME_BMP_1882, COMP_FRAME_BMP_1882)

        CASE __INFORM_THEME_IMAGE_MENUCHECKMARK
            CONST SIZE_MENUCHECKMARK_BMP_710~& = 710~&
            CONST COMP_MENUCHECKMARK_BMP_710%% = -1%%
            CONST DATA_MENUCHECKMARK_BMP_710 = _
                "eNpy8j3GxAAGVUCcA8TsQCwKxIA+xugEQCiIYRUXcXoFlzw5yF+wxeC7Bnrkypm/DB+H42hhZnnvZ/8A9OAeQI637rIvivPeJobYO3axrzsRxXkv" + _
                "iT09uAeQ46277As7+w+Yz6hS"

            __UI_ImageData = Base64_LoadResourceString(DATA_MENUCHECKMARK_BMP_710, SIZE_MENUCHECKMARK_BMP_710, COMP_MENUCHECKMARK_BMP_710)

        CASE __INFORM_THEME_IMAGE_NOTFOUND
            CONST SIZE_NOTFOUND_BMP_7802~& = 7802~&
            CONST COMP_NOTFOUND_BMP_7802%% = -1%%
            CONST DATA_NOTFOUND_BMP_7802 = _
                "eNrt2TWSG1EQANA2XcDMdujQNzBHhiOYNDzLzHstKTcny5gsM5NYaqtnSri8+qXfwe8anq6uNwz/9ceOxwAAAB0AUAUAzwDgOQBcgqdwBY4LzHb+" + _
                "zAUiEAikLcuKcOzJ5jhOGJkG2WT6lE/5lE/5ZmdnMRgMiuyppjDf6Ogo9vf3497enoiealFNoT7qRQXVKtenfMoXDqcPJx/OkeIbGIjhtWszWFe3" + _
                "ienDBG9Zff2ml9PfH6u4b3k5iffvzyHANNbWbmBpkJvWUc7SUlLK8Z2cjOeM5MlGW9uWt+zOnTkcGYlLvT4mJoqN7e2HbBJ9h43U3749h8PDcVb3" + _
                "F9Ncz/m+fFlndf/r7PSP6Y0bs3jrlr8fGxs3Wfi6unwbuYaG4jg2Fse7d31jU9OmVF9nZ7EtGzSd3Y+UI8P382c0ZxscPHQt0LKskXIr7tvdTdE5" + _
                "dtJ1Susoh3LV+4FEn/IpXygUwn///gnpqZZIXzgcxpmZGaE91VT/N84Xvb29WF1dfabedV00DCNeSV9TUxPG43E8y/+UmpqaXU3TXnLzZW3fv39/" + _
                "BZng5JubmyuycfItLS1hbW3tTuaYviYXJx/Z6urqtgOBwBsyMfJlbTu6rr8lDyNf1kbH9B1ZGPmytt3MfvtADk6+5eXlwzYmvvn5ec9mmuZHD8DI" + _
                "V19fT7Y9Xdc/cWxfNQwjYdv2JzhH/AddXsRq"

            __UI_ImageData = Base64_LoadResourceString(DATA_NOTFOUND_BMP_7802, SIZE_NOTFOUND_BMP_7802, COMP_NOTFOUND_BMP_7802)

        CASE __INFORM_THEME_IMAGE_PROGRESSCHUNK
            CONST SIZE_PROGRESSCHUNK_BMP_602~& = 602~&
            CONST COMP_PROGRESSCHUNK_BMP_602%% = -1%%
            CONST DATA_PROGRESSCHUNK_BMP_602 = _
                "eNpz8o1iYgCDKiDOAWIuIOYBYkYGBQZmBlzgPwTBOGQAv2ax/8RguRei2PFLVKzzWhY3fgWi5cDY7JkCKn4KwebPULH6TQlUfEscK3Y/bw3BF6D4" + _
                "Igzb/PdAwkn7YonGyfvi/ifvR+AUMI5HwVn707Hi7P0ZQBqMwezmwzU4ccvhWhAGs9ddWQbEywliYuMNAO7oIA0="

            __UI_ImageData = Base64_LoadResourceString(DATA_PROGRESSCHUNK_BMP_602, SIZE_PROGRESSCHUNK_BMP_602, COMP_PROGRESSCHUNK_BMP_602)

        CASE __INFORM_THEME_IMAGE_PROGRESSTRACK
            CONST SIZE_PROGRESSTRACK_BMP_806~& = 806~&
            CONST COMP_PROGRESSTRACK_BMP_806%% = -1%%
            CONST DATA_PROGRESSTRACK_BMP_806 = _
                "eNpy8lVjZgCDKiDOAWJOIBYGYkYGBQagFA7wH4JgHDLAfyBYtnrN/9q6+v8ZGRkwDOYvB4oDAZguLy8HlEoGGgCEQBD99r4pAPqlUiKFO4N3jsWg" + _
                "ZWjXa2trnlprkOrsL6V8dYKc/jDEOQeOswOz97bMWssyc07L9N4do7VlWmuWGWPc39nPzjvfMGF+GP4d7i/VUkryh3yiPEg9cs74DJ8Eqd8L2HdB" + _
                "Rg=="

            __UI_ImageData = Base64_LoadResourceString(DATA_PROGRESSTRACK_BMP_806, SIZE_PROGRESSTRACK_BMP_806, COMP_PROGRESSTRACK_BMP_806)

        CASE __INFORM_THEME_IMAGE_RADIOBUTTON
            CONST SIZE_RADIOBUTTON_BMP_5530~& = 5530~&
            CONST COMP_RADIOBUTTON_BMP_5530%% = -1%%
            CONST DATA_RADIOBUTTON_BMP_5530 = _
                "eNqc0iEOwjAYBeDHlkkkpkEge4RpdBGcYGIGgUShOAdqvnpHgITb1EyXJ/6QJwDxN3xp2vcX2tL94b4BAOAK4AxgDeBEK+zQ4ler9rGBo9VaP16P" + _
                "Z6CBZlqsHyhYjdY2lCjTSJE6ijbOljeyJtGFWv0uyVvLk+wna/2fdVn2P0rW00TF+l6yUc4bZX6iKibJotxPJ/OFqiiSdVbv+B3HeRz35vl/fO/A" + _
                "8d7E7bgNNNBMC802Dl9qG0r0breawWTLwmAerfJnx6tkbdu2bdtPY9s2GmPbtm22trYrOLd55q4dDPvU95eCMoR98zQKtEnoHB1FSWE6on54Afw/" + _
                "P+c7O8yNPu/eidzMaDQNDKFtZAydE5PomZ5F39wCSoszEfzpA+A7Oz6GjOQQVHd0ob63T4rjO8Hf96MHUVzfgIqWVhS1NOBT/Q/Y47UXn2q/R/1Q" + _
                "n4IjT6E3NtwDusoq4vBV0Qkcjj+GPZH7cKbnOcQp96hP+JOWl4vckhLicJXuOlxSdjnO01yIvRF7sdtrv8KTvgg/wwO+R4ZOTxy+r/DCbR13WXFX" + _
                "4FD8UXyq+0HRRz+F/6ffvhMpeXnEIb1ERxzv4UsrT+oTvjAHvhe+hfp9o+AET+EL/WQOwjeRz/GXroUMxxyYH9+56wF5Uh99oZ/MwbkHv65vv72j" + _
                "L73/Cu4N1eCqvGXcFqTB0++8LO3oO28+jKeitLiz1Iibi424tsCAK3QGXKwx4OYADZ5/5WGXjr4Wr8UT1Sa8VGdAcM8G2udW4de1gftKtwXOoaOf" + _
                "fPYK3mw244MWIxqnp3C8xh97ffbj2zIvNExOKjjyFHq/SNPjwzYzkoc34d0S7tDRb0u9eI88qU/p6PH2dXzZaUHXwiquLbrJoaN7fA6SJ/XRF6Wj" + _
                "3rl6HO+xIGtsC+GDyQ4dPV7tT330hX7aOvrtqwge+hH+/Sa0zs+AON4jT+qjL/STOdh3NEyjFzjeI0/qoy/0kzm4dNTj40chcORJffSFfjIH5ifr" + _
                "KHlSH32hn8zh79LRlNMvo7NGi82NNfTU6ZHm8aq0o5GfPYjWilxsbm1h22CAwWiEyWyGxWJBT70esV896tLRprIsrKytYW1jQ4qz72jcD89hfmkJ" + _
                "SysrmFychn99IA74HoCftasLa4sKjjyF3urCVMzMz4O40FbHjvpV+yv3qE/4MzQyhMnZWRB3vVNH9/seUnjSF+FnhTYJY1NTIC62P8Gho+Qp9NFP" + _
                "4X/UN09jZGICxA1OjxLHe+RJfYovzMG+o2WaBIETPIUv9JM5uHQ0+MN7IMMxB+Yn6yh5Uh99oZ/M4Xfo6L96j8q/5HtU/iXfo2pfYo/+ujvqev7R" + _
                "e/T/PSrBSfeoHCffo3KcfI/KcfI9KsP9w/fo/3u027rBhpZWlK+u+RW1Pcp3zl9qe9QdRm2PusOo7tHeRcdb1Pf/HlXvaPKpl9FRrcHG+iq6VfZo" + _
                "xGcPoLk8B+t229JoMsG8wx5tKMkUG0qKs+9o7HfPig0lxznt0UptEiamp1Vx1Cf86e3vxejEhCqOvgg/S/LiMDg6qoqjn8L/iK+fRN/wsCqOOdh3" + _
                "tCgndkccc3DuaOD7d0GGYw7MT9ZR8qQ++kI/mcPv0dGfAFRLXXE="

            __UI_ImageData = Base64_LoadResourceString(DATA_RADIOBUTTON_BMP_5530, SIZE_RADIOBUTTON_BMP_5530, COMP_RADIOBUTTON_BMP_5530)

        CASE __INFORM_THEME_IMAGE_SCROLLBUTTONS
            CONST SIZE_SCROLLBUTTONS_BMP_9370~& = 9370~&
            CONST COMP_SCROLLBUTTONS_BMP_9370%% = -1%%
            CONST DATA_SCROLLBUTTONS_BMP_9370 = _
                "eNpy8p2lAhADGFQBcQ4QCwJxBxAzMigwMDMAuC8HH7+iIIz+j43TuG7jhjXj2mFT27ZtG2vbmvZk98vmZmZxX93Jnt/TfOf55u1IZfobWsgva/hq" + _
                "1lpjTW9uWPnDs1Zy75R9unXMPt48GgKfbx+36qcXzToazeo/G46+sidWpNo+3DE5jGqpNqt8/p2XIcB26C9/atZcaVTt88tyDB5L7Qezuo+4gXkY" + _
                "XF/zzqz6jVnVa3x4iHH+cuDXcaUELjwDFc9iB/ONJQml90/jccdDv3e8HMqVCfKCvMBDf+yI8yI5p9DBtWoqhyTHdueJHZxjlAdyzsM+nQN3cyXQ" + _
                "hw90nyG5vnJUPDoXOUAO5xFyVD25IAfreW94Xr2DnthhdS+uDDu4r7xD7Q3yyKV7RY98uqbW/PbmsIP+zhY8yfF4V0ni6P76UA7y9KpH95D7pfcE" + _
                "yPKcs5/0+e7rtaKld+zNlQO2YOqEQjw7twuHlu3Bia1ZKIdD+dySR46C9dscy+bOKupQXuQ5fF7kOFwu9nhHmI+9Yzqsv48+psMMDADrmY7uaKlm" + _
                "2dNYAry79IjQwfvYU/LI0Vv6WNAjQkfj6+s5hA6+CTJwDr4DGIdyICMHYzPzRXh79aCue2EH46POhbG149O9HMi4a1r/8moW1D/k4B3JcLjnlLwY" + _
                "93Pa/vGuIOfQNhE49P2Z5IJlETuaK5N+lkWwPnb0dgN9TB1uvXNk13/taHl3KztPRg6NR0UgqzFoz+p5dm7byix2r5qrMciOblleeAwiK4e+eXOg" + _
                "/iXH7MkTizqUF+N18L+zIOfQNhE5Gl5dgyQXLYvAwT1P+lkW0frAoTGOPqYOtz5yNJbkETnaG/KIHH29WThHfjlH0TFIDsaRA+sX2dOzO+3JmR3j" + _
                "4vHp7bZ3zfxv7dkBBsBQDIPh+996lJ8wFYXgCQIhzwD6bbb1oLwHTXfzIByH257bffbTGw9iT9QItE94kHrO6lLeg/7fow509yD2z3tQPagedHrD" + _
                "O1LOYbwH5VxKHIgtDkSuHjT7elA96H0PImcP2vyH3nnQ5j/aJzyIsNl8yHkQ0b32JPWvoB5UD3r2DeNI9M6DNv/RPuFBhM3mQ8aDiO6lP3vQ7PMe" + _
                "VA/6AN9nbCQ="

            __UI_ImageData = Base64_LoadResourceString(DATA_SCROLLBUTTONS_BMP_9370, SIZE_SCROLLBUTTONS_BMP_9370, COMP_SCROLLBUTTONS_BMP_9370)

        CASE __INFORM_THEME_IMAGE_SCROLLHBUTTONS
            CONST SIZE_SCROLLHBUTTONS_BMP_9370~& = 9370~&
            CONST COMP_SCROLLHBUTTONS_BMP_9370%% = -1%%
            CONST DATA_SCROLLHBUTTONS_BMP_9370 = _
                "eNpy8p2lAhADGFQBcQ4QCwJxBxAzMigwMDPgAv8hCM4BUF8OPHZFURT+j43TuG7jhjXj2mFTj23btm3bb7erryvN2dnFOeXs5Mtcre/i6I1/yeKI" + _
                "yNqsLHeXy0RDjozWZspgZaoMVKQAk6GqNJlpKRDZXBJZGBI49sebJaTW+6uFDkGtzohMtX2iA5jgPDiYaBFZmRLUXFsRHdFnmesXmR+AOwq2AY7P" + _
                "9orMdItMd8EHD2J4fzrg53O5GC54IpOttgPbS6NESmtq6NHPg+sNR8eX7DiBA8CBPIEH11sO5LSD6HeyHfhWyxOE38Px/MiBd0QWbUaMPME9tQNu" + _
                "ZuECzDttzb90TDbmmg5AB/4ip6FjujmfDhzHuEF/pYOwfU3HfHsxHWjX6BjaWKSHLrYTrqGP31RWeiroiF6/tQqP8zzKBY/j2BlpoAN5XMtr2IZo" + _
                "L44TgCz6Oe7j9u/9PQktjrHu4ni5cvJIEK257wQO7tenv/SCOTiY9y166Aisv+K4dfHc73CAX3aQQIf2/N3nONgnX/ORiIvt4FqHfYK8u14sT+Aa" + _
                "YjowHndHG0WzN9ZEcA0xHUtdZV4YDvwm8EE78DsA85AXyNCBuRnbIfSUJPC7BzswP/JdMLduDtZ6gYz+pgsdJV6gDosDfd3TofshHMCrn24M1Dgg" + _
                "T7Cv0A6uexrHo88ZDq7PxMljX2M69nYcmOe+4q+tDajD6FjtrfTOI0MH56MQkOUc9OH+Jcl9ddeL9/cuCueglBe3Q+cgZOngb14vUIfFcf740d/i" + _
                "AB4O/O/sgDzBvsZyLHaWahyPOmc6VPs7eewrTIee65jnvsJ2LI06IM9tA9uxseiD7djf80M7/Es7gucgZDkHxT++Ji05b6U5+81P0ZT1WmIeXP6c" + _
                "/diOHWAAEIZQEL7/rRcIRnis+cmLAA1AfPUgy4Nmx1FyDxojGAN55EGL4/geBBNKPYidelA96KAHcf5yGM+D8nvLg2hCmQfBhepB9aDDHkQXyj2I" + _
                "JuR70O5AlgcFJpT/hnpQPeisB9GF8gZNyPeg3YF8D6IJ5R5EF6oHWR70AVdotFU="

            __UI_ImageData = Base64_LoadResourceString(DATA_SCROLLHBUTTONS_BMP_9370, SIZE_SCROLLHBUTTONS_BMP_9370, COMP_SCROLLHBUTTONS_BMP_9370)

        CASE __INFORM_THEME_IMAGE_SCROLLHTHUMB
            CONST SIZE_SCROLLHTHUMB_BMP_5402~& = 5402~&
            CONST COMP_SCROLLHTHUMB_BMP_5402%% = -1%%
            CONST DATA_SCROLLHTHUMB_BMP_5402 = _
                "eNpy8pUSZQCDKiDOAWIxILYBYkYGBQZmBkAvZoFrRRBE0V2xCOLsAF0GUeJoDCK4u7u7u7t/d9dLDsnFKp8OMzVUOKlianKe9avu/2YK+R9B+udQ" + _
                "5xup9Zn6X17Vx5tHa9Hx6JzwQXb0Pr8sDXVLxEC7pr8+FKjlUfW6r0XE17snRUx+vi91vJbankvtL8mV6olP90S8uXJABI+l7g++DyrVU18eiHh1" + _
                "aZ8ItTzhNfCca8HzI15e3Pu7l+fc9Y5cpY5eXg/ens++p1Jt74sLe0Tw/qi/jV4Nopd1zFpT75c6RC+vg7VMv6+FXKWO7y+9kT5ei++pUod1hhM3" + _
                "j8fa4DtUqo3XsD8j4tOtY9LEmDKj5d4pPivWXyM8P79b82bPSuXhya2udfvw+hTsszMr7AZCU5P1mZwQYa/X2sz0l3rOwcvaSyB4PfPAtYFC3wQv" + _
                "exGwl5ADhb6v/+FlHw30vbgC1KbUD962B2fUev+0s2vnUt8EL/0EgpcZlIG9MPj6OusvBVw4ee7kTNiHmpqT764d0uJFc1Kxc+TdLX24cSQFXPZ7" + _
                "/WZA2Ot9KYHgbX94lsdzdm1KfRO8f5sBZFPoB+/o+9tGYx/uGPD1Up86eNX6DDhrOLuGYt918H4/E34E1waKfRO8SftQ8A73AOdKcoDrgXhf9E5P" + _
                "p2Av8LdmVuDC2dTcaWpOchZ4cmaHTm5clgLnU5wH1izR8Nub+nz7eAq4zm5dhddzJwUCJyTO3+DlNwnofHw+1M6FPgQv8y6B4GVfMp57xtcLferg" + _
                "nek3EP+/1HcO3s43/h3BtYFS3wQvszOF/+NNO/fZCxofUVbgwsmau3VonR6d2pbC5d2r+d41Nie/AfoYLw0="

            __UI_ImageData = Base64_LoadResourceString(DATA_SCROLLHTHUMB_BMP_5402, SIZE_SCROLLHTHUMB_BMP_5402, COMP_SCROLLHTHUMB_BMP_5402)

        CASE __INFORM_THEME_IMAGE_SCROLLHTRACK
            CONST SIZE_SCROLLHTRACK_BMP_4746~& = 4746~&
            CONST COMP_SCROLLHTRACK_BMP_4746%% = -1%%
            CONST DATA_SCROLLHTRACK_BMP_4746 = _
                "eNpy8u0SYgCDKiDOAWJBIHYBYkYGBQZmBlzgPwTBOGQAQLv1cOBQAEVhuP9+poWJs4ltPdss4o9zF18JB5Uyq7As+R5pxCXhe4h9LnK50OJ8nXMV" + _
                "zrly9vk9WCdOmWG71h9WRe73CEzOU9+Dc+WsA6fMuOsQS/Z9LN71MH/VegvuooHdoz9e+YPkB8kPkh8kPwiTDpIOkg6SDgJqkctWew=="

            __UI_ImageData = Base64_LoadResourceString(DATA_SCROLLHTRACK_BMP_4746, SIZE_SCROLLHTRACK_BMP_4746, COMP_SCROLLHTRACK_BMP_4746)

        CASE __INFORM_THEME_IMAGE_SCROLLTHUMB
            CONST SIZE_SCROLLTHUMB_BMP_5402~& = 5402~&
            CONST COMP_SCROLLTHUMB_BMP_5402%% = -1%%
            CONST DATA_SCROLLTHUMB_BMP_5402 = _
                "eNpy8pUSZQCDKiDOAWJ+II4AYkYGBQZmBkD7ZYFbZwwE4Vv1EBX3BsVLlElcZlGZmZmZIczMzJypPv1aVQ4aynmrzMP9vOuxsnFmC2U/9iYi1FEl" + _
                "9bWq7v1tlT2/rNJnl1Ty9KKJ94jvVPHyqho/3ZMGOqX2CsE2fb6vkOgufiFjRfS2aKLhqyYbv80ovhur+yz1NIloy3v8g20tlbrqpe6GTLxGnTVS" + _
                "W7nUUizEOkTtu1suaxwyzli+n5nlcxh6clm+NxY15U1nmwrie4aN6xk2tmfWS+g5L9dzrueZ61JvqEfME2YQs4DPTLaGsb2lr2QsnOUwT2x/7AXB" + _
                "jNd/ydYlmosydmxEocH61KHGssWLggQDa+8/3DjiJcuHNY4Z3fzlgVq+PmSOsj++z3zDj4lxEcYbSxiLjBV+uCwxK2t1mceBLHJ6jmCje+4peRnD" + _
                "Itgkr1y2N4D9TV7lzjf9jNJ9Tq87PjYj21/+Rr5BrrH0Ejrr4Jj9Va+va92qJUGCgeX1UNV79uglcmGMJTQ5KQ124Q2fM/s1XP2BfLV+e8SdFR/J" + _
                "nIetdViYeVn+lhnbVBBV13oeqfnoW9dYq5vKRnsFy+9Ugs+wAT7XJ7C/9Xxh488XdiGdr9szbErP87LcLX2DXJiUWces5L58Zuca3Tu2fV7dP75D" + _
                "5/esh0O6emgr+1JHwVMvkQtjLKGhXjxC2V29KQ+fOV/+z8YnPBMxH8t9m1kcw1LX2Pb8J6F1k3qG/a112yuSfU7wCja659z55s43dE7C2H3y4r6N" + _
                "yrt/2tGXOyec9yZy4b4DxCNBXw=="

            __UI_ImageData = Base64_LoadResourceString(DATA_SCROLLTHUMB_BMP_5402, SIZE_SCROLLTHUMB_BMP_5402, COMP_SCROLLTHUMB_BMP_5402)

        CASE __INFORM_THEME_IMAGE_SCROLLTRACK
            CONST SIZE_SCROLLTRACK_BMP_4746~& = 4746~&
            CONST COMP_SCROLLTRACK_BMP_4746%% = -1%%
            CONST DATA_SCROLLTRACK_BMP_4746 = _
                "eNpy8u0SYgCDKiDOAWJBIHYBYkYGBQZmBlzgPwTBOGQAQDt1bYBAGARRuP9+aAGHBHd3d4cH3HbwRycTvGznC5dNH55357y9DBkyZDgavVSMQyPB" + _
                "qZXyuvVy3Pt5mBZhXoPtAPZTOC6s8wauB7C8vQwZMmS4GnY3gt34n90f5nBawWVrt7cT3C/W42r/y7J9AA0ZMmTIkCFDhowvXIhmng=="

            __UI_ImageData = Base64_LoadResourceString(DATA_SCROLLTRACK_BMP_4746, SIZE_SCROLLTRACK_BMP_4746, COMP_SCROLLTRACK_BMP_4746)

        CASE __INFORM_THEME_IMAGE_SLIDERDOWN
            CONST SIZE_SLIDERDOWN_BMP_4742~& = 4742~&
            CONST COMP_SLIDERDOWN_BMP_4742%% = -1%%
            CONST DATA_SLIDERDOWN_BMP_4742 = _
                "eNpy8m0TYgCDKiDOAWJuIM4EYkYGBQZmBoBwgf8QBOOQAQDt1QOMnFEcBPDGrG3bto24tm3btm3bPdu2bdue3hRvlVvU2CSz/H3+Tx7KAfJ5Y27J" + _
                "d5UxsHfCWzMLPNEzVOkMbB0QGh+PJzr69EpdfGYWwuIT4BsWLnxZjolOTUNwbJyCN3Vxh5GDMxKysunEu7x/pm8EKw9vJGXnILE0dIy0D4qJhV94" + _
                "BF4YmcLGywfJObn0NAo+PCER/hGRwqaUYZmIxKQ/yWptZBQtbL18YevhCWs3D5g7ucBMLvo2dnhrYobXphZw8PGHo7cfPWzcPWDjJgm3p+e8frC2" + _
                "41zSc/88H/lwDjm3ZXbp5tndanXz7cMzWH3pAQ7vXKnS7XxmgI43AzF770l6pa7b2xyEe3qhzUkr4ZU5xkpHV8GbvL2F/a/N0P19vnAAZPycfadw" + _
                "Yt9a2Jm+wjSLAhkX5uWF5NhoiT9ti3NHNsPZ6oOCY+T92cObaIVLT08HDb/z3cPGhtHaX2jXOxViikUBen/I51zIpNP9SLQ95/jZWutgu0sh1jh8" + _
                "9pPNJZlgVoDu73LR8XYIrpzcAU9HE+i4+YOe+1/vKMlqh0LQ73pmiIdXD3Eu6bl/no98OIec2x/SzXnHJ6vVzdU356HSvgaYsHksvVJX5VwT8P5W" + _
                "2FBXeCVOdEHe8xo33FuCKhckDoCMn7hlnOjmwCfjlHazwqa62m7+5Xa6ziL0fzwGNS+14FzIpNLhhqi4tZ7o5kKD1ZjyYT7o+z4aJdLr4QhUOV/q" + _
                "DzQQ3Xxh9xD03P80nYUik9/Po+e8/vxuatdNbTf/CqtdNxdfVm/d3Ph8HurerY8pe8fSK3UNdRqD97fWmTrCK3GiC/Ke17jtzRI01JM4ADJ+6n7J" + _
                "ujnaeqzSbtY+V0fbzb/cLnBZhJHWo9FUvznnQib1HjVA7Yt1RTdXuq/CXOd5oB9hNVJkqOVwNNQt9ffri26+cX8Ieu5/vstCkTnOc+k5rxp38yPr" + _
                "gYo/"

            __UI_ImageData = Base64_LoadResourceString(DATA_SLIDERDOWN_BMP_4742, SIZE_SLIDERDOWN_BMP_4742, COMP_SLIDERDOWN_BMP_4742)

        CASE __INFORM_THEME_IMAGE_SLIDERTRACK
            CONST SIZE_SLIDERTRACK_BMP_222~& = 222~&
            CONST COMP_SLIDERTRACK_BMP_222%% = -1%%
            CONST DATA_SLIDERTRACK_BMP_222 = _
                "eNpy8r3HAAFVQJwDxKxQzMigwMDMgAv8hyA4B1DJOCMwDABQ9P5zrRvUa+2l1lLbNl+cPW/7NE6l0SSWziBxfT7ZX2843G5a7TbD3ZHT/cHj/cZs" + _
                "szPdbFmdzqzPF/7/P75QmEKpLHl6r9XtEU0mxQ+P/icARUtgHg=="

            __UI_ImageData = Base64_LoadResourceString(DATA_SLIDERTRACK_BMP_222, SIZE_SLIDERTRACK_BMP_222, COMP_SLIDERTRACK_BMP_222)

        CASE ELSE
            ERROR 51
    END SELECT
END FUNCTION

' Converts a normal string or binary data to a base64 string
FUNCTION Base64_Encode$ (s AS STRING)
    CONST BASE64_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    DIM srcSize AS _UNSIGNED LONG: srcSize = LEN(s)
    DIM srcSize3rem AS _UNSIGNED LONG: srcSize3rem = srcSize MOD 3
    DIM srcSize3mul AS _UNSIGNED LONG: srcSize3mul = srcSize - srcSize3rem
    DIM buffer AS STRING: buffer = SPACE$(((srcSize + 2) \ 3) * 4) ' preallocate complete buffer
    DIM j AS _UNSIGNED LONG: j = 1

    DIM i AS _UNSIGNED LONG: FOR i = 1 TO srcSize3mul STEP 3
        DIM char1 AS _UNSIGNED _BYTE: char1 = ASC(s, i)
        DIM char2 AS _UNSIGNED _BYTE: char2 = ASC(s, i + 1)
        DIM char3 AS _UNSIGNED _BYTE: char3 = ASC(s, i + 2)

        ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHR(char1, 2)))
        j = j + 1
        ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL((char1 AND 3), 4) OR _SHR(char2, 4)))
        j = j + 1
        ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL((char2 AND 15), 2) OR _SHR(char3, 6)))
        j = j + 1
        ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (char3 AND 63))
        j = j + 1
    NEXT i

    ' Add padding
    IF srcSize3rem > 0 THEN
        char1 = ASC(s, i)

        ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHR(char1, 2)))
        j = j + 1

        IF srcSize3rem = 1 THEN
            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL(char1 AND 3, 4)))
            j = j + 1
            ASC(buffer, j) = 61 ' "="
            j = j + 1
            ASC(buffer, j) = 61 ' "="
        ELSE ' srcSize3rem = 2
            char2 = ASC(s, i + 1)

            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL((char1 AND 3), 4) OR _SHR(char2, 4)))
            j = j + 1
            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL(char2 AND 15, 2)))
            j = j + 1
            ASC(buffer, j) = 61 ' "="
        END IF
    END IF

    Base64_Encode = buffer
END FUNCTION


' Converts a base64 string to a normal string or binary data
FUNCTION Base64_Decode$ (s AS STRING)
    DIM srcSize AS _UNSIGNED LONG: srcSize = LEN(s)
    DIM buffer AS STRING: buffer = SPACE$((srcSize \ 4) * 3) ' preallocate complete buffer
    DIM j AS _UNSIGNED LONG: j = 1
    DIM AS _UNSIGNED _BYTE index, char1, char2, char3, char4

    DIM i AS _UNSIGNED LONG: FOR i = 1 TO srcSize STEP 4
        index = ASC(s, i): GOSUB find_index: char1 = index
        index = ASC(s, i + 1): GOSUB find_index: char2 = index
        index = ASC(s, i + 2): GOSUB find_index: char3 = index
        index = ASC(s, i + 3): GOSUB find_index: char4 = index

        ASC(buffer, j) = _SHL(char1, 2) OR _SHR(char2, 4)
        j = j + 1
        ASC(buffer, j) = _SHL(char2 AND 15, 4) OR _SHR(char3, 2)
        j = j + 1
        ASC(buffer, j) = _SHL(char3 AND 3, 6) OR char4
        j = j + 1
    NEXT i

    ' Remove padding
    IF RIGHT$(s, 2) = "==" THEN
        buffer = LEFT$(buffer, LEN(buffer) - 2)
    ELSEIF RIGHT$(s, 1) = "=" THEN
        buffer = LEFT$(buffer, LEN(buffer) - 1)
    END IF

    Base64_Decode = buffer
    EXIT FUNCTION

    find_index:
    IF index >= 65 AND index <= 90 THEN
        index = index - 65
    ELSEIF index >= 97 AND index <= 122 THEN
        index = index - 97 + 26
    ELSEIF index >= 48 AND index <= 57 THEN
        index = index - 48 + 52
    ELSEIF index = 43 THEN
        index = 62
    ELSEIF index = 47 THEN
        index = 63
    END IF
    RETURN
END FUNCTION


' This function loads a resource directly from a string variable or constant (like the ones made by Bin2Data)
FUNCTION Base64_LoadResourceString$ (src AS STRING, ogSize AS _UNSIGNED LONG, isComp AS _BYTE)
    ' Decode the data
    DIM buffer AS STRING: buffer = Base64_Decode(src)

    ' Expand the data if needed
    IF isComp THEN buffer = _INFLATE$(buffer, ogSize)

    Base64_LoadResourceString = buffer
END FUNCTION


' Loads a binary file encoded with Bin2Data
' Usage:
'   1. Encode the binary file with Bin2Data
'   2. Include the file or it's contents
'   3. Load the file like so:
'       Restore label_generated_by_bin2data
'       Dim buffer As String
'       buffer = LoadResource   ' buffer will now hold the contents of the file
FUNCTION Base64_LoadResourceData$
    DIM ogSize AS _UNSIGNED LONG, resize AS _UNSIGNED LONG, isComp AS _BYTE
    READ ogSize, resize, isComp ' read the header

    DIM buffer AS STRING: buffer = SPACE$(resize) ' preallocate complete buffer

    ' Read the whole resource data
    DIM i AS _UNSIGNED LONG: DO WHILE i < resize
        DIM chunk AS STRING: READ chunk
        MID$(buffer, i + 1) = chunk
        i = i + LEN(chunk)
    LOOP

    ' Decode the data
    buffer = Base64_Decode(buffer)

    ' Expand the data if needed
    IF isComp THEN buffer = _INFLATE$(buffer, ogSize)

    Base64_LoadResourceData = buffer
END FUNCTION

' Simple hash function: k is the 32-bit key and l is the upper bound of the array
FUNCTION __HashTable_GetHash~& (k AS _UNSIGNED LONG, l AS _UNSIGNED LONG)
    $CHECKING:OFF
    ' Actually this should be k MOD (l + 1)
    ' However, we can get away using AND because our arrays size always doubles in multiples of 2
    ' So, if l = 255, then (k MOD (l + 1)) = (k AND l)
    ' Another nice thing here is that we do not need to do the addition :)
    __HashTable_GetHash = k AND l
    $CHECKING:ON
END FUNCTION


' Subroutine to resize and rehash the elements in a hash table
SUB __HashTable_ResizeAndRehash (hashTable() AS HashTableType)
    DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)

    ' Resize the array to double its size while preserving contents
    DIM newUB AS _UNSIGNED LONG: newUB = _SHL(uB + 1, 1) - 1
    REDIM _PRESERVE hashTable(0 TO newUB) AS HashTableType

    ' Rehash and swap all the elements
    DIM i AS _UNSIGNED LONG: FOR i = 0 TO uB
        IF hashTable(i).U THEN SWAP hashTable(i), hashTable(__HashTable_GetHash(hashTable(i).K, newUB))
    NEXT i
END SUB


' This returns an array index in hashTable where k can be inserted
' If there is a collision it will grow the array, re-hash and copy all elements
FUNCTION __HashTable_GetInsertIndex& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_GetHash(k, uB)

    IF hashTable(idx).U THEN
        ' Used slot
        IF hashTable(idx).K = k THEN
            ' Duplicate key
            __HashTable_GetInsertIndex = __HASHTABLE_KEY_EXISTS
        ELSE
            ' Collision
            __HashTable_ResizeAndRehash hashTable()
            __HashTable_GetInsertIndex = __HashTable_GetInsertIndex(hashTable(), k)
        END IF
    ELSE
        ' Empty slot
        __HashTable_GetInsertIndex = idx
    END IF
END FUNCTION


' This function returns the index from hashTable for the key k if k is in use
FUNCTION __HashTable_GetLookupIndex& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_GetHash(k, uB)

    IF hashTable(idx).U THEN
        ' Used slot
        IF hashTable(idx).K = k THEN
            ' Key found
            __HashTable_GetLookupIndex = idx
        ELSE
            ' Unknown key
            __HashTable_GetLookupIndex = __HASHTABLE_KEY_UNAVAILABLE
        END IF
    ELSE
        ' Unknown key
        __HashTable_GetLookupIndex = __HASHTABLE_KEY_UNAVAILABLE
    END IF
END FUNCTION


' Return TRUE if k is available in the hash table
FUNCTION HashTable_IsKeyPresent%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    $CHECKING:OFF
    HashTable_IsKeyPresent = (__HashTable_GetLookupIndex(hashTable(), k) >= 0)
    $CHECKING:ON
END FUNCTION


' Remove an element from the hash table
SUB HashTable_Remove (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM idx AS LONG: idx = __HashTable_GetLookupIndex(hashTable(), k)

    IF idx >= 0 THEN
        hashTable(idx).U = __HASHTABLE_FALSE
    ELSE
        ERROR 9
    END IF
END SUB


' Inserts a long value in the table using a key
SUB HashTable_InsertLong (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS LONG)
    DIM idx AS LONG: idx = __HashTable_GetInsertIndex(hashTable(), k)

    IF idx >= 0 THEN
        hashTable(idx).U = __HASHTABLE_TRUE
        hashTable(idx).K = k
        hashTable(idx).V = v
    ELSE
        ERROR 9
    END IF
END SUB


' Returns the long value from the table using a key
FUNCTION HashTable_LookupLong& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM idx AS LONG: idx = __HashTable_GetLookupIndex(hashTable(), k)

    IF idx >= 0 THEN
        HashTable_LookupLong = hashTable(idx).V
    ELSE
        ERROR 9
    END IF
END FUNCTION
