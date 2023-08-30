': This form was generated by
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------
SUB __UI_LoadForm

    DIM __UI_NewID AS LONG

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "gifplaySample", 300, 281, 0, 0, 0)
    SetCaption __UI_NewID, "gifplay Sample"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).Font = SetFont("arial.ttf", 12)

    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "PictureBox1", 230, 230, 36, 12, 0)
    Control(__UI_NewID).Stretch = True
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Align = __UI_Center
    Control(__UI_NewID).VAlign = __UI_Middle

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "LoadBT", 123, 23, 36, 247, 0)
    SetCaption __UI_NewID, "Load globe.gif"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "PlayBT", 80, 23, 186, 247, 0)
    SetCaption __UI_NewID, "Play"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).CanHaveFocus = True

END SUB

SUB __UI_AssignIDs
    gifplaySample = __UI_GetID("gifplaySample")
    PictureBox1 = __UI_GetID("PictureBox1")
    LoadBT = __UI_GetID("LoadBT")
    PlayBT = __UI_GetID("PlayBT")
END SUB
