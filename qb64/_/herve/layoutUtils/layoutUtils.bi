$INCLUDEONCE
 
type layoutUtils_layoutType
    id as integer
    layoutName as string
    fullpath as string
    content as string
    resolved as string
    prepared as integer
end type
 
type layoutUtils_elementType
    index as integer
    position as integer
    length as integer
    reference as string
end type
 
redim shared layoutUtils_layoutList(0) as layoutUtils_layoutType
redim shared layoutUtils_elementList(0) as layoutUtils_elementType